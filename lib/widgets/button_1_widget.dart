import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';

class Button1Widget extends StatelessWidget {
  Function _onPressed;
  String _title;

  Button1Widget(this._title, this._onPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: OutlinedButton.icon(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 13)),
              side: MaterialStateProperty.all(
                  BorderSide(color: Main.color[900], width: 1)),
              foregroundColor: MaterialStateProperty.all(Main.color[900]),
              backgroundColor: MaterialStateProperty.all(Colors.grey[200])),
          onPressed: _onPressed,
          icon: Icon(
            Icons.calculate,
            size: 20,
          ),
          label: Text(_title)),
    );
  }
}
