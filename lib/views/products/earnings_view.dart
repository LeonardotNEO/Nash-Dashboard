import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/utils/Calculate_numbers.dart';
import 'package:nash_dashboard/widgets/box_withlogo_widget.dart';

class EarningsView extends StatefulWidget {
  QuerySnapshot _nexEarningsContract = Main.nashEarningsContract;
  QuerySnapshot _nashEarningsStats = Main.nashEarningsStats;
  DocumentSnapshot _aavePools = Main.aavePools;

  @override
  _EarningsViewState createState() => _EarningsViewState();
}

class _EarningsViewState extends State<EarningsView> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> tokens = [];

    for (dynamic token in widget._nexEarningsContract.docs.first["tokens"]) {
      tokens.add(token);
    }
    _sortTokens(tokens);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxWithLogoWidget(
            "Current APY",
            Text(
              double.parse(widget._nashEarningsStats.docs[0]["apy"])
                      .toStringAsFixed(2) +
                  "%",
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
            Icons.account_balance),
        BoxWithLogoWidget(
            "Total value locked in Nash earnings",
            Text(
              "${CalculateNumbers.doubleInRightFormat(_totalValueLocked(tokens).toStringAsFixed(0))}\$",
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
            Icons.attach_money),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [..._tokenUI(tokens, widget._aavePools)],
          ),
        )
      ],
    );
  }
}

double _totalValueLocked(dynamic tokens) {
  double totalValueLocked = 0;

  tokens.forEach((token) {
    Map<String, dynamic> tokenInfo = token["tokenInfo"];
    var balance = token["rawBalance"];
    double value = BigInt.parse(balance) /
        BigInt.from(pow(10, int.parse(tokenInfo["decimals"])));

    totalValueLocked += value;
  });

  return totalValueLocked;
}

List<Widget> _tokenUI(dynamic tokens, DocumentSnapshot pools) {
  List<Widget> widgets = [
    Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text("Symbol", style: TextStyle(fontSize: 12)),
          ),
          Expanded(
              child: Text(
            "APY (Aave 30d avg)",
            style: TextStyle(fontSize: 12),
          )),
          Expanded(
            child: Container(
                width: 110,
                alignment: Alignment.centerRight,
                child: Text("Deposited", style: TextStyle(fontSize: 12))),
          ),
        ],
      ),
    )
  ];

  tokens.forEach((token) {
    Map<String, dynamic> tokenInfo = token["tokenInfo"];
    var balance = token["rawBalance"];
    double value = BigInt.parse(balance) /
        BigInt.from(pow(10, int.parse(tokenInfo["decimals"])));

    String symbol = (tokenInfo["symbol"] as String)
        .toUpperCase()
        .replaceFirst(RegExp(r'A'), 'a');
    String valueString = value.toStringAsFixed(0);
    String apy = "";

    Image image;
    for (dynamic token in Main.tokens["tokens"]) {
      if (symbol.toLowerCase() == (token["symbol"] as String).toLowerCase()) {
        image = Image.network(
          token["image"],
          height: 25,
          width: 25,
        );
      }
    }

    // check apy with aave and assign them to a pair
    pools["tokens"].forEach((pair) {
      if (symbol.contains(pair["symbol"])) {
        double apydouble = double.parse(pair["avg30DaysLiquidityRate"]) * 100;
        double incentivedouble = double.parse(pair["aIncentivesAPY"]) * 100;
        double sum = apydouble + incentivedouble;

        apy = sum.toStringAsFixed(2) + "%";
      }
    });

    if (value >= 1) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      child: image != null ? image : SizedBox.shrink(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(symbol, style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              Expanded(child: Text(apy, style: TextStyle(fontSize: 12))),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                    CalculateNumbers.doubleInRightFormat(valueString) + "\$",
                    style: TextStyle(fontSize: 12)),
              )),
            ],
          ),
        ),
      ));
    }
  });

  return widgets;
}

void _sortTokens(List<dynamic> tokens) {
  tokens.sort((a, b) {
    double valueA = BigInt.parse(a["rawBalance"]) /
        BigInt.from(pow(10, int.parse(a["tokenInfo"]["decimals"])));

    double valueB = BigInt.parse(b["rawBalance"]) /
        BigInt.from(pow(10, int.parse(b["tokenInfo"]["decimals"])));

    return valueB.compareTo(valueA);
  });
}
