import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FsRef {
  static final profileRef = FirebaseFirestore.instance.collection('profiles');

  static CollectionReference<Map<String, dynamic>> health(String doc) =>
      profileRef.doc(doc).collection('health');

  static CollectionReference<Map<String, dynamic>> insurance(String doc) =>
      profileRef.doc(doc).collection('insurance');
}

class StRef {
  static final profileImgRef = FirebaseStorage.instance.ref('profiles');
  static final insuranceImgRef = FirebaseStorage.instance.ref('insurance');
}
