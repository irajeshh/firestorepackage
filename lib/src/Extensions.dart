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
    if (exists) {
      final String c = collectionLink;
      final String d = docPath.id.replaceAll('+', '%2B');
      return '$c~2F$d';
    } else {
      return _baseDB;
    }
  }
}

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
}
