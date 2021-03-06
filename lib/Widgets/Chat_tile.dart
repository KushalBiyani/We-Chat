import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/screens/chat.dart';

class UserListBuilder extends StatelessWidget {
  const UserListBuilder({
    Key key,
    @required int limit,
    @required this.currentUserId,
    @required this.listScrollController,
  })  : _limit = limit,
        super(key: key);

  final int _limit;
  final String currentUserId;
  final ScrollController listScrollController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .limit(_limit)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) =>
                buildItem(context, snapshot.data.docs[index], currentUserId),
            itemCount: snapshot.data.docs.length,
            controller: listScrollController,
          );
        }
      },
    );
  }
}

Widget buildItem(
    BuildContext context, DocumentSnapshot document, String currentUserId) {
  if (document.data()['id'] == currentUserId) {
    return Container();
  } else {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black26))),
      child: TextButton(
        child: Row(
          children: <Widget>[
            document.data()['photoUrl'] != null
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(document.data()['photoUrl']),
                  )
                : Container(
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.grey,
                      size: 60,
                    ),
                  ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${document.data()['nickname']}',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 10.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        peerId: document.id,
                        peerName: document.data()['nickname'],
                        peerAvatar: document.data()['photoUrl'],
                      )));
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
    );
  }
}
