import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/widgets/box_premade_widget.dart';

class InfoView extends StatefulWidget {
  DocumentSnapshot _nexStatsCoingecko = Main.nexStatsCoingecko;

  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  @override
  Widget build(BuildContext context) {
    return _nexDescription();
  }

  Widget _nexDescription() {
    return Column(
      children: [
        BoxPremadeWidget(
          "About Nash",
          [
            Text(
              "${widget._nexStatsCoingecko["description"]["en"]}",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
          padding: EdgeInsets.all(20),
        ),
      ],
    );
  }
}
