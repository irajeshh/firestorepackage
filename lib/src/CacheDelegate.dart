part of '../firestorepackage.dart';

abstract class FirestoreCacheDelegate {
  Future<String?> getString(String key);
  Future<bool> set(String key, String value);
  Future<bool> delete(String key);
}
