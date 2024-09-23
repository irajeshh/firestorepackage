part of '../firestorepackage.dart';

// ignore: subtype_of_sealed_class
class InvalidDoc extends Doc {
  @override
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
  DocumentReference<Json> get reference => throw UnimplementedError();
}
