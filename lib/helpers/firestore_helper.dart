

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    FirebaseFirestore get db{
      return _db;
    }
}