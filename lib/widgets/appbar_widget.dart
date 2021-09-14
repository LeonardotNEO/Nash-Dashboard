import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarWidget extends StatelessWidget {
  String _title;
  List<Widget> actions;
  Widget leading;
  Color backgroundColor;
  Color foregroundColor;
  double elevation;
  double toolbarHeight;

  AppBarWidget(this._title,
      {this.actions,
      this.leading,
      this.backgroundColor,
      this.foregroundColor,
      this.elevation,
      this.toolbarHeight});

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      elevation: elevation,
      backgroundColor: backgroundColor,
      title: Text(
        _title,
        style: TextStyle(color: foregroundColor, fontSize: 25),
      ),
      leading: leading,
      automaticallyImplyLeading: true,
      actions: [
        TextButton(
            onPressed: () => _launchURL(),
            child: Row(
              children: [Text("Nash"), Icon(Icons.arrow_forward)],
            ))
      ],
    );
  }

  _launchURL() async {
    const url = "https://nash.io/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
