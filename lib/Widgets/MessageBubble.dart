import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Map data;
  final bool itsMe;

  const MessageBubble({Key key, this.data, this.itsMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry border = itsMe
        ? BorderRadiusDirectional.only(
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            bottomStart: Radius.circular(10))
        : BorderRadiusDirectional.only(
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            bottomEnd: Radius.circular(10));
    return Container(
      child: Column(
          children: <Widget>[
            // Text
            data['type'] == 1
                ? Container(
                    decoration: BoxDecoration(
                      color: itsMe ? Colors.lightBlueAccent : Colors.white,
                      borderRadius: border,
                    ),
                    height: 250,
                    width: 250,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Hero(
                          tag: data['timestamp'],
                          child: Image.network(
                            data['content'],
                            height: 195,
                            width: 195,
                            fit: BoxFit.fill,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return DetailScreen(data);
                          }));
                        },
                      ),
                    ),
                  )
                : Container(
                    child: Text(
                      data['content'],
                      style: TextStyle(color: Colors.black),
                      textAlign: itsMe ? TextAlign.end : TextAlign.start,
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    decoration: BoxDecoration(
                      color: itsMe ? Colors.lightBlueAccent : Colors.white,
                      borderRadius: border,
                    ),
                  ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(data['timestamp']))),
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 9.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: itsMe
                  ? EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0)
                  : EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            )
          ],
          crossAxisAlignment:
              itsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start),
      margin: itsMe
          ? EdgeInsets.only(bottom: 5.0, right: 10.0)
          : EdgeInsets.only(bottom: 5.0, left: 10),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map data;
  DetailScreen(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: data['timestamp'],
            child: Image.network(data['content']),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
