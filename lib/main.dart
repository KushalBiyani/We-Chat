import 'package:flutter/material.dart';
import 'package:we_chat/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:we_chat/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatefulWidget {
  @override
  _FlashChatState createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MyApp.id,
      routes: {
        MyApp.id: (context) => MyApp(),
        LoginScreen.id: (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
