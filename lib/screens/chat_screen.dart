import 'package:we_chat/components/message_stream.dart';
import 'package:we_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user != null) {
          loggedInUser = user;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Material(
            child: Container(
              color: Colors.lightBlueAccent,
              // child: CircleAvatar(
              //   backgroundImage: NetworkImage(loggedInUser.photoURL),
              // ),
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
                child: Icon(
                  Icons.logout,
                  size: 40,
                ),
                onTap: () {
                  _auth.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                }),
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Material(
              elevation: 20,
              child: Container(
                decoration: kMessageContainerDecoration,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Icon(
                            Icons.send,
                            size: 40,
                          ),
                          onTap: () {
                            messageTextController.clear();
                            if (messageText != null) {
                              _firestore.collection('messages').add({
                                'text': messageText,
                                'sender': loggedInUser.displayName,
                                'created': FieldValue.serverTimestamp()
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
