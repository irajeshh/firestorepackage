part of '../firestorepackage.dart';

///To manage crud operations on Firestore without any exceptions
class FirestoreService {
  FirestoreService._privateConstructor();
  static final FirestoreService _instance = FirestoreService._privateConstructor();

  ///Quick instance
  static FirestoreService get instance => _instance;

  ///Instance of the firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///Default limit of a query result
  static const int queryLimit = 30;

  static Ref _getReference(final DocumentPath documentPath) {
    return firestore.collection(documentPath.collection).doc(documentPath.id);
  }

  ///To read/get a document for the given path
  static Future<Doc> get(final DocumentPath documentPath) async {
    Doc documentSnapshot = InvalidDoc();
    try {
      assert(
        documentPath != DocumentPath.invalid,
        'Invalid DocumentPath: $documentPath',
      );
      documentSnapshot = await _getReference(documentPath).get();
    } on Exception catch (exception) {
      debugPrint('Error $exception');
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
  }) async {
    bool created = false;
    try {
      await _getReference(documentPath).set(data, SetOptions(merge: true));
      created = true;
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
    } on Exception catch (exception) {
      if (createIfNotFound) {
        debugPrint("Creating as the doc doesn't exists...");
        final bool created = await set(data: data, documentPath: documentPath);
        updated = created;
        debugPrint('Created: $created');
      } else {
        updated = false;
        debugPrint('Error info: $exception');
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
    } on Exception catch (exception) {
      debugPrint('Error $exception');
    }
    return deleted;
  }

  ///To check if the given document id exists in the given collection
  static Future<bool> checkExists(DocumentPath documentPath) async {
    final Doc doc = await get(documentPath);
    return doc.exists;
  }
}
