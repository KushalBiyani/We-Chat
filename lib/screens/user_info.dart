import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/components/loading.dart';
import 'package:we_chat/components/rounded_button.dart';
import '../constants.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
User user = FirebaseAuth.instance.currentUser;
final _firestore = FirebaseFirestore.instance;

class UserInfoDetaols extends StatefulWidget {
  static const String id = 'user_info';
  final String nickname;
  final String photoUrl;
  UserInfoDetaols({Key key, @required this.nickname, @required this.photoUrl})
      : super(key: key);
  @override
  _UserInfoDetaolsState createState() =>
      _UserInfoDetaolsState(photoUrl: photoUrl, nickname: nickname);
}

class _UserInfoDetaolsState extends State<UserInfoDetaols> {
  _UserInfoDetaolsState({@required this.photoUrl, @required this.nickname});
  String nickname;
  String photoUrl;
  bool showSpinner = false;
  File _image;
  String email = user.email;
  final picker = ImagePicker();
  var profile;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: nickname);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        profile = FileImage(_image);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Container(
                  child: AspectRatio(
                    aspectRatio: 10 / 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                          image:
                              _image == null ? NetworkImage(photoUrl) : profile,
                        )),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              FloatingActionButton(
                onPressed: getImage,
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                controller: _controller,
                onChanged: (value) {
                  nickname = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: ""),
              ),
              RoundedButton(
                title: 'Update',
                colour: Colors.blueAccent,
                onPressed: () async {
                  if (nickname != null) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      if (_image != null) {
                        try {
                          await storage
                              .ref('profileImage/$email')
                              .putFile(_image);
                        } catch (e) {
                          // e.g, e.code == 'canceled'
                        }
                        try {
                          photoUrl = await firebase_storage
                              .FirebaseStorage.instance
                              .ref('profileImage/$email')
                              .getDownloadURL();
                        } catch (e) {
                          // e.g, e.code == 'canceled'
                        }
                      }

                      _firestore
                          .collection('users')
                          .doc(user.uid)
                          .update({'nickname': nickname, 'photoUrl': photoUrl});
                      Navigator.pop(context);
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          child: showSpinner ? const Loading() : Container(),
        ),
      ]),
    );
  }
}
