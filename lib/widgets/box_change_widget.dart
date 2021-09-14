import 'package:flutter/material.dart';

class BoxChangeWidget extends StatelessWidget {
  String title;
  String content;
  bool minus;
  Color color;

  BoxChangeWidget(this.title, this.content, this.minus, {this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color != null ? color : Colors.grey[50]),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 14,
                  )),
              Text(
                content,
                style: TextStyle(
                    fontSize: 14,
                    color: minus
                        ? Colors.redAccent[700]
                        : Colors.greenAccent[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
