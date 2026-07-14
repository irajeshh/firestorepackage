part of '../firestorepackage.dart';

// ignore: subtype_of_sealed_class
class CachedDoc extends InvalidDoc {
  final String _cachedId;
  final String _cachedCollection;
  final Json _cachedData;

  CachedDoc(this._cachedId, this._cachedCollection, this._cachedData) {
    set(id: _cachedId, exists: true, data: _cachedData);
  }

  @override
  DocumentReference<Json> get reference =>
      FirebaseFirestore.instance.collection(_cachedCollection).doc(_cachedId);
}
