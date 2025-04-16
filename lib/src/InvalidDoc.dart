part of '../firestorepackage.dart';

// ignore: subtype_of_sealed_class
class InvalidDoc extends Doc {
  bool _exists = false;
  Json? _data;
  String _id = 'invalid';

  void setExists(final bool v) => _exists = v;
  void setData(final Json d) => _data = d;
  void setID(final String? i) {
    if (i != null) {
      _id = i;
    }
  }

  @override
  bool get exists => _exists;

  @override
  String get id => _id;

  @override
  Json? data() => _data ?? <String, dynamic>{};

  @override
  Object? get(final Object field) => data();

  @override
  operator [](final Object field) {
    throw UnimplementedError();
  }

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  DocumentReference<Json> get reference => throw UnimplementedError();
}
