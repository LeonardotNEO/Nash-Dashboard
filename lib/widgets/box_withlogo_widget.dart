import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';

class BoxWithLogoWidget extends StatelessWidget {
  String header;
  Widget content;
  IconData icon;
  Widget topRight;
  Color color;

  BoxWithLogoWidget(this.header, this.content, this.icon,
      {this.topRight, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                color: color != null ? color : Main.color[900],
                borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      header,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    topRight != null ? topRight : SizedBox.shrink(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      content,
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 70,
            transform: Matrix4.translationValues(0.0, -40.0, 0.0),
            child: Icon(
              icon,
              color: Colors.white10,
              size: 300,
            ),
          )
        ]),
      ),
    );
  }
}
