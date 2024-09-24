part of '../firestorepackage.dart';

// ignore: subtype_of_sealed_class
///Default firestore doc model
class InvalidDoc extends Doc {
  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  operator [](final Object field) {
    throw UnimplementedError();
  }

  @override
  Json? data() {
    return <String, dynamic>{};
  }

  @override
  bool get exists => false;

  @override
  Object? get(final Object field) {
    return data();
  }

  @override
  String get id => 'invalid';

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  Ref get reference => throw UnimplementedError();
}
