part of '../firestorepackage.dart';

// ignore: public_member_api_docs
extension DocExtension on Doc {
  ///Returns the [DocumentPath] for this Doc
  DocumentPath get docPath {
    return DocumentPath.fromReference(reference);
  }

  ///Returns Json from Doc
  Json get toJson => data() ?? <String, dynamic>{};

  static final String _baseDB = 'https://console.firebase.google.com/project/${FirestorepackageConfig.projectID}/firestore/databases/-default-/data/~2F';

  ///Firestore link of the collection of the document
  String get collectionLink => exists ? '$_baseDB${docPath.collection}' : _baseDB;

  ///Firestore link of the document
  String get documentLink {
    if (exists && id != 'invalid') {
      final String c = collectionLink;
      final String d = docPath.id.replaceAll('+', '%2B');
      return '$c~2F$d';
    } else {
      return _baseDB;
    }
  }
}

///Customized snippets to simplify the queries
extension QueryExtension on Queryy {
  ///To simplify the queries accross any projects
  Queryy applySearch(final List<String>? tags) {
    late List<String> _tags = tags ?? const <String>[];
    if (_tags.isNotEmpty) {
      if (_tags.length > 9) {
        _tags = _tags..removeRange(9, _tags.length - 1);
      }
      return where('tags', arrayContainsAny: _tags);
    } else {
      return this;
    }
  }

  ///Only query if the values are passed
  Queryy whereIf(final String key, final Object? value) {
    if (value != null) {
      if (value == NULL) {
        return where(key, isNull: true);
      } else {
        return where(key, isEqualTo: value);
      }
    } else {
      return this;
    }
  }

  ///Only startAfter if the doc is not null
  Queryy startAfterDoc(final Doc? doc) {
    if (doc != null) {
      return startAfterDocument(doc);
    }
    return this;
  }

  ///Only sort if the key if the values are empty to avoid creating indices
  Queryy orderByIf({
    final String key = 'createdAt',
    final bool descending = true,
    required final List<Object?> valuesTobeEmpty,
  }) {
    bool allValsEmpty = valuesTobeEmpty.where((final Object? v) => v != null).isEmpty;
    if (allValsEmpty) {
      return orderBy(key, descending: descending);
    } else {
      return this;
    }
  }
}
