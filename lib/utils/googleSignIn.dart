import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

User currentUser;
SharedPreferences prefs;

Future<User> signInWithGoogle() async {
  prefs = await SharedPreferences.getInstance();

  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
}
