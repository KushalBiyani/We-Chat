import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_chat/screens/imageView.dart';

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
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: data['timestamp'],
                        child: CachedNetworkImage(
                          imageUrl: data['content'].toString(),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fill,
                          height: 250,
                          width: 250,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen(
                              data['content'], data['timestamp']);
                        }));
                      },
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
