library firestorepackage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';

export 'package:models/models.dart';

part 'src/DocumentPath.dart';
part 'src/Extensions.dart';
part 'src/InvalidDoc.dart';
part 'src/Model.dart';
part 'src/Service.dart';
part 'src/Typedefs.dart';

///A configuration file which can be called from parent project
class FirestorepackageConfig {
  FirestorepackageConfig._();

  ////projectID must be initialized inorder to get collection & document url
  static String projectID = 'unknown';
}
