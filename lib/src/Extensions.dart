part of '../firestorepackage.dart';

// ignore: public_member_api_docs
extension DocExtension on Doc {
  ///Returns the [DocumentPath] for this Doc
  DocumentPath get docPath {
    return DocumentPath.fromReference(reference);
  }

  ///Returns Json from Doc
  Json get toJson => data() ?? <String, dynamic>{};

  static final String _baseDB = 'https://console.firebase.google.com/project/${FirestorepackageConfig.productID}/firestore/databases/-default-/data/~2F';

  ///Firestore link of the collection of the document
  String get collectionLink => '$_baseDB${docPath.collection}';

  ///Firestore link of the document
  String get documentLink {
    final String c = collectionLink;
    final String d = docPath.id.replaceAll('+', '%2B');
    return '$c~2F$d';
  }
}
