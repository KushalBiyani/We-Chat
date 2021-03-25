import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Widgets/loading.dart';
import 'package:we_chat/Widgets/rounded_button.dart';
import 'package:we_chat/utils/firebaseUserHelper.dart';

class UserInfoDetaols extends StatefulWidget {
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
  var error;
  File _image;
  var profile;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: nickname);
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
                onPressed: () async {
                  _image = await getImage();
                  setState(() {
                    if (_image != null) {
                      profile = FileImage(_image);
                    }
                  });
                },
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
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              RoundedButton(
                title: 'Update',
                colour: Colors.blueAccent,
                onPressed: () async {
                  if (nickname.trim() != null && _image != null) {
                    setState(() {
                      showSpinner = true;
                    });
                    error = updateUser(_image, nickname, photoUrl);
                    if (error) {
                      Fluttertoast.showToast(
                          msg: error.code.toString(),
                          backgroundColor: Colors.black45,
                          textColor: Colors.red);
                    } else {
                      Navigator.pop(context);
                    }
                    setState(() {
                      showSpinner = false;
                    });
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
