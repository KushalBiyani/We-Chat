import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Widgets/MessageBubble.dart';

class MessageStreamBuilder extends StatelessWidget {
  final String groupChatId;
  final int limit;
  final dynamic listScrollController;
  final dynamic listMessage;
  final String id;
  const MessageStreamBuilder(
      {Key key,
      @required this.limit,
      @required this.groupChatId,
      @required this.listMessage,
      @required this.listScrollController,
      @required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: groupChatId == ''
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent)))
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(groupChatId)
                    .collection(groupChatId)
                    .orderBy('timestamp', descending: true)
                    .limit(limit)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent)));
                  } else {
                    listMessage.addAll(snapshot.data.docs);

                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(id, snapshot.data.docs[index]),
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ));
  }
}

Widget buildItem(String id, DocumentSnapshot document) {
  return MessageBubble(
    itsMe: document.data()['idFrom'] == id,
    data: document.data(),
  );
}
