import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

User user = FirebaseAuth.instance.currentUser;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
final _firestore = FirebaseFirestore.instance;

dynamic updateUser(_image, nickname, photoUrl) async {
  String email = user.email;
  if (_image != null) {
    try {
      await storage.ref('profileImage/$email').putFile(_image);
    } catch (e) {
      return e;
    }
    try {
      photoUrl = await storage.ref('profileImage/$email').getDownloadURL();
    } catch (e) {
      return e;
    }
  }
  try {
    _firestore
        .collection('users')
        .doc(user.uid)
        .update({'nickname': nickname, 'photoUrl': photoUrl});
  } catch (e) {
    return e;
  }
}
