part of '../firestorepackage.dart';

///To manage crud operations on Firestore without any exceptions
class FirestoreService {
  FirestoreService._privateConstructor();
  static final FirestoreService _instance = FirestoreService._privateConstructor();

  ///Quick instance
  static FirestoreService get instance => _instance;

  ///Instance of the firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Optional cache delegate to store/restore document data locally.
  static FirestoreCacheDelegate? cacheDelegate;

  /// Only these collections will be cached. If empty, nothing is cached.
  static List<String> cachedCollections = [];

  ///To get the collection reference
  static Queryy collection(final String collectionID) => firestore.collection(collectionID);

  ///Default limit of a query result
  static const int queryLimit = 30;

  static Ref _getReference(final DocumentPath documentPath) {
    ///To comply with CSOS PermitID system we are replacing '/' with '~' in document IDs
    return firestore.collection(documentPath.collection).doc(documentPath.id.replaceAll('/', '~'));
  }

  static String _encodePart(String part) => base64Url.encode(utf8.encode(part));
  static String _cacheKey(DocumentPath path) =>
      'db_cache_${_encodePart(path.collection)}_${_encodePart(path.id)}';
  static String _timeKey(DocumentPath path) =>
      'db_time_${_encodePart(path.collection)}_${_encodePart(path.id)}';

  ///To read/get a document for the given path
  static Future<Doc> get(final DocumentPath documentPath, {bool useCache = true}) async {
    Doc documentSnapshot = InvalidDoc();
    if (documentPath.collection.isValid && documentPath.id.isValid) {
      final String cacheKey = _cacheKey(documentPath);
      final bool shouldCache =
          useCache && cacheDelegate != null && cachedCollections.contains(documentPath.collection);

      if (shouldCache) {
        try {
          final String? cachedStr = await cacheDelegate!.getString(cacheKey);
          if (cachedStr != null) {
            final Json cachedMap = jsonDecode(cachedStr) as Json;
            return CachedDoc(documentPath.id, documentPath.collection, cachedMap);
          }
        } catch (e) {
          debugPrint('Error reading cache for ${documentPath.collection}/${documentPath.id}: $e');
        }
      }

      try {
        assert(
          documentPath != DocumentPath.invalid,
          'Invalid DocumentPath: $documentPath',
        );
        documentSnapshot = await _getReference(documentPath).get();

        if (shouldCache && documentSnapshot.exists && documentSnapshot.data() != null) {
          try {
            await cacheDelegate!.set(cacheKey, jsonEncode(documentSnapshot.data()));
            final String timeKey = _timeKey(documentPath);
            await cacheDelegate!.set(timeKey, DateTime.now().millisecondsSinceEpoch.toString());
          } catch (e) {
            debugPrint('Error writing cache for ${documentPath.collection}/${documentPath.id}: $e');
          }
        }
      } on Exception catch (exception) {
        debugPrint('Error $exception');
      }
    } else {
      print('Empty path: ${documentPath.collection}/${documentPath.id}');
    }

    return documentSnapshot;
  }

  ///To add a document without any specific ID value to a collection
  static Future<DocumentReference<Json>?> add({
    required final String collectionID,
    required final Json data,
  }) async {
    final CollectionReference<Json> reference = firestore.collection(collectionID);
    DocumentReference<Json>? documentReference;
    try {
      documentReference = await reference.add(data);
    } on Exception catch (exception) {
      debugPrint('Error $exception');
    }
    return documentReference;
  }

  ///To add a document with specific id to a collection
  static Future<bool> set({
    required final Json data,
    required final DocumentPath documentPath,
    bool merge = true,
  }) async {
    bool created = false;
    try {
      await _getReference(documentPath).set(data, SetOptions(merge: merge));
      created = true;

      if (cacheDelegate != null && cachedCollections.contains(documentPath.collection)) {
        final String cacheKey = _cacheKey(documentPath);
        await cacheDelegate!.set(cacheKey, jsonEncode(data));
        final String timeKey = _timeKey(documentPath);
        await cacheDelegate!.set(timeKey, DateTime.now().millisecondsSinceEpoch.toString());
      }
    } on Exception catch (exception) {
      debugPrint('Error $exception');
    }
    return created;
  }

  ///To update the entire document with transaction to avoid multiple
  ///operations at same time
  static Future<bool> update({
    required final DocumentPath documentPath,
    required final Json data,
    final bool createIfNotFound = false,
    final VoidCallback? ifNotExistFn,
  }) async {
    bool updated = false;
    final DocumentReference<Json> reference = _getReference(documentPath);
    try {
      await firestore.runTransaction((final Transaction transaction) async {
        try {
          transaction.update(reference, data);
          updated = true;
        } on Exception catch (exception) {
          updated = false;
          debugPrint('Transaction Error $exception');
        }
      });

      if (cacheDelegate != null) {
        final String cacheKey = _cacheKey(documentPath);
        await cacheDelegate!.delete(cacheKey);
        final String timeKey = _timeKey(documentPath);
        await cacheDelegate!.delete(timeKey);
      }
    } on Exception catch (exception) {
      final bool notExist = '$exception'.contains('cloud_firestore/not-found');
      if (notExist) {
        if (createIfNotFound) {
          debugPrint("Creating as the doc doesn't exists...");
          final bool created = await set(data: data, documentPath: documentPath);
          updated = created;
          debugPrint('Created: $created');
        } else {
          updated = false;
          debugPrint('Error info: $exception');
        }
        if (ifNotExistFn != null) {
          ifNotExistFn();
        }
      } else {
        debugPrint('Some other error: $exception');
      }
    }
    return updated;
  }

  ///To delete a document based on given id value
  static Future<bool> delete(final DocumentPath documentPath) async {
    bool deleted = false;
    try {
      await _getReference(documentPath).delete();
      deleted = true;
      if (cacheDelegate != null) {
        final String cacheKey = _cacheKey(documentPath);
        await cacheDelegate!.delete(cacheKey);
        final String timeKey = _timeKey(documentPath);
        await cacheDelegate!.delete(timeKey);
      }
    } on Exception catch (exception) {
      debugPrint('Error $exception');
    }
    return deleted;
  }

  ///To check if the given document id exists in the given collection
  static Future<bool> checkExists(final DocumentPath documentPath) async {
    final Doc doc = await get(documentPath, useCache: false);
    return doc.exists;
  }
}
