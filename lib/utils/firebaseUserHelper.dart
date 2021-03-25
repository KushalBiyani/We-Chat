import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final GoogleSignIn googleSignIn = GoogleSignIn();
User user = FirebaseAuth.instance.currentUser;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
final _firestore = FirebaseFirestore.instance;
ImagePicker imagePicker = ImagePicker();
PickedFile pickedFile;

Future signInWithGoogle() async {
  final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
}

Future logOut() async {
  await FirebaseAuth.instance.signOut();
  await googleSignIn.disconnect();
  await googleSignIn.signOut();
}

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

Future<Map> getDetails(currentUserId) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: currentUserId)
      .get();
  return result.docs[0].data();
}

Future registerUser(firebaseUser) async {
  final QuerySnapshot result = await _firestore
      .collection('users')
      .where('id', isEqualTo: firebaseUser.uid)
      .get();
  final List<DocumentSnapshot> documents = result.docs;
  if (documents.length == 0) {
    // Update data to server if new user
    _firestore.collection('users').doc(firebaseUser.uid).set({
      'nickname': firebaseUser.displayName,
      'photoUrl': firebaseUser.photoURL,
      'id': firebaseUser.uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}

Future getImage() async {
  pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
      maxHeight: 250,
      maxWidth: 250,
      imageQuality: 50);
  return File(pickedFile.path);
}

Future uploadImage(groupChatId) async {
  pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
      maxHeight: 750,
      maxWidth: 750,
      imageQuality: 50);
  File imageFile = File(pickedFile.path);
  if (imageFile != null) {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    await firebase_storage.FirebaseStorage.instance
        .ref('chatImages/$groupChatId/$fileName')
        .putFile(imageFile);
    return await firebase_storage.FirebaseStorage.instance
        .ref('chatImages/$groupChatId/$fileName')
        .getDownloadURL();
  } else {
    return null;
  }
}
