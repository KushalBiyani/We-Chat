import 'package:we_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

User loggedInUser;

class MyApp extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget navigate;
  User currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if (currentUser != null) {
      navigate = HomeScreen(
        currentUserId: currentUser.uid,
      );
    } else {
      navigate = LoginScreen();
    }
    return SplashScreen(
        seconds: 2,
        navigateAfterSeconds: navigate,
        title: Text(
          'Flash Chat',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('images/logo.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.white);
  }
}
