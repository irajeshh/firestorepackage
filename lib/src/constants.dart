// ignore_for_file: constant_identifier_names
part of '../firestorepackage.dart';
///This is used to query where the value is null in firestore.
///But in UI, we need to show the null value as 'null' because a direct [null]
///will be conditionally avoided as there is no need to query for [null] keys!

const String NULL = 'NULL';
