import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';

class BoxPremadeWidget extends StatelessWidget {
  String title;
  List<Widget> widgets;
  Widget right;
  Color color;
  EdgeInsets padding;

  BoxPremadeWidget(this.title, this.widgets,
      {this.right, this.color, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
              color: color != null ? color : Main.color[900],
              borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          padding: padding != null ? padding : EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                color != null ? Colors.black87 : Colors.white)),
                    right != null ? right : SizedBox.shrink()
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [...widgets],
              ),
            ],
          ),
        ));
  }
}
