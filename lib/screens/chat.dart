import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_chat/Widgets/inputIcon.dart';
import 'package:we_chat/Widgets/loading.dart';
import 'package:we_chat/utils/MessageStreamBuilder.dart';
import 'package:we_chat/utils/getImage.dart';
import 'package:we_chat/utils/sendMessage.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerName;
  final String peerAvatar;
  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: peerAvatar != null
                  ? NetworkImage(peerAvatar)
                  : AssetImage('images/nullprofile.jpg'),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              peerName.length > 15 ? peerName.substring(0, 14) : peerName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ],
        ),
      ),
      body: ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);
  @override
  State createState() =>
      ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});
  String peerId;
  String peerAvatar;
  String id;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId;
  SharedPreferences prefs;
  dynamic message;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    groupChatId = '';
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void setMessage(content, type) {
    message = message = {
      'idFrom': id,
      'idTo': peerId,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': content,
      'type': type
    };
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    imageFile = await getImage();
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      String fileName =
          groupChatId + DateTime.now().millisecondsSinceEpoch.toString();

      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('chatImages/$fileName')
            .putFile(imageFile);
        imageUrl = await firebase_storage.FirebaseStorage.instance
            .ref('chatImages/$fileName')
            .getDownloadURL();
        setState(() {
          isLoading = false;
          setMessage(imageUrl, 1);
          sendMessage(groupChatId, message);
        });
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      }
    }
  }

  void sendText() {
    if (textEditingController.text.trim() != '') {
      setMessage(textEditingController.text, 0);
      sendMessage(groupChatId, message);
      textEditingController.clear();
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.white,
          textColor: Colors.red);
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black12,
            child: Column(children: <Widget>[
              // List of messages
              MessageStreamBuilder(
                id: id,
                groupChatId: groupChatId,
                limit: _limit,
                listMessage: listMessage,
                listScrollController: listScrollController,
              ),
              InputWidget(
                imageFunction: uploadFile,
                stickerFunction: getSticker,
                sendFunction: sendText,
                textController: textEditingController,
                keyboardFocus: focusNode,
              )
            ]),
          ),
          // Loading
          Positioned(child: isLoading ? const Loading() : Container()),
        ],
      ),
      onWillPop: onBackPress,
    );
  }
}
