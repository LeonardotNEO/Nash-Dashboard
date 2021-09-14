import 'package:flutter/material.dart';
import 'package:nash_dashboard/views/graphs/charts_view.dart';
import 'package:nash_dashboard/views/products/product_view.dart';
import 'package:nash_dashboard/views/token/token_view.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/views/staking/staking_view.dart';

class BottomBarWidget extends StatefulWidget {
  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 5),
        height: 60,
        child: Row(children: [
          Expanded(
            child: _button(
              "Token",
              () => Main.setCurrentPage(TokenView(), "Token"),
              image: Image.network(Main.nexStatsCoingecko["image"]["small"]),
            ),
          ),
          Expanded(
            child: _button(
              "Products",
              () => Main.setCurrentPage(ProductView(), "Products"),
              icon: Icons.apps,
            ),
          ),
          Expanded(
            child: _button(
              "Staking",
              () => Main.setCurrentPage(StakingView(), "Staking"),
              icon: Icons.account_balance,
            ),
          ),
          Expanded(
            child: _button(
              "Charts",
              () => Main.setCurrentPage(GraphsView(), "Charts"),
              icon: Icons.bar_chart,
            ),
          ),
        ]));
  }

  Widget _button(String title, onPressed, {IconData icon, Image image}) {
    return Center(
      child: TextButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            icon != null ? Icon(icon) : SizedBox.shrink(),
            image != null
                ? SizedBox(width: 22, height: 22, child: image)
                : SizedBox.shrink(),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
