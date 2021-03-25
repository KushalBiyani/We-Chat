import 'dart:io';
import 'package:we_chat/Widgets/Chat_tile.dart';
import 'package:we_chat/Widgets/Exit_popup.dart';
import 'package:we_chat/Widgets/loading.dart';
import 'package:we_chat/screens/login_screen.dart';
import 'package:we_chat/screens/user_info.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/utils/firebaseUserHelper.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState({Key key, @required this.currentUserId});

  final String currentUserId;
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onItemMenuPress(Choice choice) async {
    if (choice.title == 'Log out') {
      this.setState(() {
        isLoading = true;
      });
      await logOut();
      this.setState(() {
        isLoading = false;
      });
      Navigator.popAndPushNamed(context, LoginScreen.id);
    } else {
      final Map result = await getDetails(currentUserId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoDetaols(
            nickname: result['nickname'],
            photoUrl: result['photoUrl'],
          ),
        ),
      );
    }
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ExitDialog();
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('images/logo.png'),
            backgroundColor: Colors.white,
          ),
        ),
        title: Text(
          'We Chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        choice.icon,
                        color: Colors.blue,
                      ),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        choice.title,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: UserListBuilder(
                  limit: _limit,
                  currentUserId: currentUserId,
                  listScrollController: listScrollController),
            ),
            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
        onWillPop: openDialog,
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}
