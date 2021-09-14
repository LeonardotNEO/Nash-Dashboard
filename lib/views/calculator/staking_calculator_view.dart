import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';

class StakingCalculatorView extends StatefulWidget {
  @override
  StakingCalculatorViewState createState() => StakingCalculatorViewState();
}

class StakingCalculatorViewState extends State<StakingCalculatorView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[50],
          ),
          height: 200,
          width: 350,
          child: Column(
            children: [
              Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 30,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.clear)),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Staking calculator",
                    style: TextStyle(
                        fontSize: 16,
                        color: Main.color[900],
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
