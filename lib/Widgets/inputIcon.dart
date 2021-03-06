import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final Function imageFunction;
  final Function stickerFunction;
  final Function sendFunction;
  final TextEditingController textController;
  final FocusNode keyboardFocus;

  const InputWidget(
      {Key key,
      @required this.imageFunction,
      @required this.stickerFunction,
      @required this.sendFunction,
      @required this.textController,
      @required this.keyboardFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          InputIcon(
            icon: Icons.image,
            onPressed: imageFunction,
          ),
          InputIcon(
            icon: Icons.face,
            onPressed: stickerFunction,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  sendFunction();
                },
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                controller: textController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: keyboardFocus,
              ),
            ),
          ),
          // Button send message
          InputIcon(
            icon: Icons.send,
            onPressed: sendFunction,
          ),
        ],
      ),
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.blueGrey, width: 0.5)),
          color: Colors.white),
    );
  }
}

class InputIcon extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  const InputIcon({Key key, @required this.onPressed, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        child: IconButton(
          icon: Icon(
            icon,
            size: 30,
          ),
          onPressed: onPressed,
          color: Colors.blue,
        ),
      ),
      color: Colors.white,
    );
  }
}
