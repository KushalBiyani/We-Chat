import 'package:we_chat/Widgets/loading.dart';
import 'package:we_chat/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_chat/utils/firebaseUserHelper.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  User currentUser;
  bool isLoading = false;

  Future<Null> handleSignIn() async {
    this.setState(() {
      isLoading = true;
    });
    try {
      User firebaseUser = (await signInWithGoogle());
      if (firebaseUser != null) {
        await registerUser(firebaseUser);
        Fluttertoast.showToast(msg: "Sign in success");
        this.setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(currentUserId: firebaseUser.uid)));
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                RoundedButton(
                  title: 'Sign In With Google',
                  colour: Colors.lightBlueAccent,
                  onPressed: () => handleSignIn().catchError((err) {
                    Fluttertoast.showToast(msg: "Sign in fail");
                    this.setState(() {
                      isLoading = false;
                    });
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            child: isLoading ? const Loading() : Container(),
          ),
        ],
      ),
    );
  }
}
