import 'package:flutter/material.dart';

class CustomAlerts {
  CustomAlerts(
      {@required this.context,
      @required this.title,
      @required this.content,
      @required this.actions});

  final BuildContext context;
  final String title;
  final String content;
  final List<Widget> actions;

  showAlert() {
    var defaultActions = <Widget>[
      FlatButton(
        child: Text("OK"),
        onPressed: () => Navigator.of(context).pop(),
      )
    ];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text(title,
                style: TextStyle(
                  color: Colors.black87,
                )),
            content: Text(content),
            actions:
                actions == null || actions.isEmpty ? defaultActions : actions,
          );
        });
  }
}
