part of '../firestorepackage.dart';

///An unique data model which can handle any type of [Firebase] document paths
///to increase the productivity

class DocumentPath extends Model {
  ///Constructor
  const DocumentPath({required this.collection, required this.id});

  ///Creates a DocumentPath from [Json] map
  factory DocumentPath.fromPath(final String documentPath) {
    final List<String> list = documentPath.split('/');
    if (list.length == 2) {
      ///We don't use [SubCollections], so that the length of the [_list] must be [2] always
      final String collection = list[0];
      final String id = list[1];
      return DocumentPath(collection: collection, id: id);
    } else {
      return invalid;
    }
  }

  ///Creates a DocumentPath from [DocumentReference]
  factory DocumentPath.fromReference(final Ref reference) {
    return DocumentPath.fromPath(reference.path);
  }

  ///[CollectionID] of the firebase document
  final String collection;

  ///[DocumentID] of the firebase document
  final String id;

  ///Gives the string [path] of given [DocumentPath]
  String get toDocumentPath => '$collection/$id';

  ///Creates the [Joson] representation of the current [DocumentPath]
  @override
  Json get toJson => <String, dynamic>{
        'collection': collection,
        'id': id,
      };

  ///Default [Invalid] value to handle errors
  static DocumentPath invalid = const DocumentPath(collection: 'errors', id: '404');

  @override
  List<dynamic> get props => <dynamic>[collection, id];

  @override
  String toString() {
    return toJson.toString();
  }

  @override
  DocumentPath copyWith({
    final String? collection,
    final String? id,
  }) {
    return DocumentPath(
      collection: collection ?? this.collection,
      id: id ?? this.id,
    );
  }
}
