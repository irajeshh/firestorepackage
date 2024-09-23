part of '../firestorepackage.dart';

// ignore: public_member_api_docs
extension DocExtension on Doc {
  ///Returns the [DocumentPath] for this Doc
  DocumentPath get docPath {
    return DocumentPath.fromReference(reference);
  }

  ///Returns Json from Doc
  Json get toJson => data() ?? <String, dynamic>{};
}
