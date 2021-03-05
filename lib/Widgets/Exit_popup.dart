import 'package:flutter/material.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding:
          EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
      children: <Widget>[
        Container(
          color: Colors.lightBlueAccent,
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
          height: 150.0,
          child: Column(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.exit_to_app,
                  size: 50.0,
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(bottom: 10.0),
              ),
              Text(
                'Exit app',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Are you sure to exit app?',
                style: TextStyle(color: Colors.white70, fontSize: 14.0),
              ),
            ],
          ),
        ),
        DialogOption(
          option: 0,
          icon: Icons.cancel,
          showText: 'CANCEL',
        ),
        DialogOption(
          option: 1,
          icon: Icons.check_circle,
          showText: 'YES',
        ),
      ],
    );
  }
}

class DialogOption extends StatelessWidget {
  DialogOption({this.icon, this.option, this.showText});
  final int option;
  final IconData icon;
  final String showText;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, option);
      },
      child: Row(
        children: <Widget>[
          Container(
            child: Icon(
              icon,
              color: Colors.blue,
            ),
            margin: EdgeInsets.only(right: 10.0),
          ),
          Text(
            showText,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
