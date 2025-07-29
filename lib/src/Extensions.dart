part of '../firestorepackage.dart';

enum WhereType {
  isEqualTo,
  isNotEqualTo,
  isGreaterThan,
  isLessThan,
  arrayContains,
  arrayContainsAny,
  whereIn,
}

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
  Queryy whereIf(
    final String key,
    final Object? value, {
    final WhereType type = WhereType.isEqualTo,
  }) {
    if (value != null) {
      if (value == NULL) {
        return where(key, isNull: true);
      } else {
        switch (type) {
          case WhereType.isEqualTo:
            return where(key, isEqualTo: value);
          case WhereType.isNotEqualTo:
            return where(key, isNotEqualTo: value);
          case WhereType.isGreaterThan:
            return where(key, isGreaterThan: value);
          case WhereType.isLessThan:
            return where(key, isLessThan: value);
          case WhereType.arrayContains:
            return where(key, arrayContains: value);
          case WhereType.whereIn:
            if (value is List<Object>) {
              List<Object> _values = <Object>[...value];
              if (_values.isNotEmpty) {
                if (_values.length > 9) {
                  _values = _values..removeRange(9, _values.length - 1);
                }
                return where(key, whereIn: _values);
              } else {
                return this;
              }
            } else {
              return where(key, isEqualTo: value);
            }
          case WhereType.arrayContainsAny:
            if (value is List<Object>) {
              List<Object> _tags = <Object>[...value];
              if (_tags.isNotEmpty) {
                if (_tags.length > 9) {
                  _tags = _tags..removeRange(9, _tags.length - 1);
                }
                return where(key, arrayContainsAny: _tags);
              } else {
                return this;
              }
            } else {
              return where(key, isEqualTo: value);
            }
        }
      }
    } else {
      return this;
    }
  }

  ///Only startAfter if the doc is not null
  Queryy startAfterDoc(final Doc? lastDoc) {
    if (lastDoc != null) {
      return startAfterDocument(lastDoc);
    }
    return this;
  }

  ///Only sort if the key if the values are empty to avoid creating indices
  Queryy orderByIf({
    final String key = 'createdAt',
    final bool descending = true,
    required final List<Object?> valuesTobeEmpty,
  }) {
    final bool allValsEmpty = valuesTobeEmpty.where((final Object? v) => v != null).isEmpty;
    if (allValsEmpty) {
      return orderBy(key, descending: descending);
    } else {
      return this;
    }
  }
}
