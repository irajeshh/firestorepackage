part of '../firestorepackage.dart';

/// Alias for a Firestore document, containing data of type [Json].
typedef Doc = DocumentSnapshot<Json>;

/// Alias for a Firestore document reference, containing data of type [Json].
typedef Ref = DocumentReference<Json>;

/// Alias for a Firestore query, typically used for querying Firestore collections and containing data of type [Json].
typedef Queryy = Query<Json>;

/// Alias for a Firestore query snapshot, containing multiple documents of type [Json].
typedef QuerySnapshott = QuerySnapshot<Json>;

///To simplify the firestore query
typedef QueryDoc = QueryDocumentSnapshot<Json>;
