import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/utils/calculate_numbers.dart';
import 'package:nash_dashboard/views/calculator/staking_calculator_view.dart';
import 'package:nash_dashboard/widgets/box_premade_widget.dart';
import 'package:nash_dashboard/widgets/box_withlogo_widget.dart';
import 'package:nash_dashboard/widgets/button_1_widget.dart';

class OverViewView extends StatefulWidget {
  @override
  _OverViewViewState createState() => _OverViewViewState();
}

class _OverViewViewState extends State<OverViewView> {
  String _addresse = "ALuZLuuDssJqG2E4foANKwbLamYHuffFjg";
  DocumentSnapshot _nexStakingContract = Main.nashStakingContract;
  DocumentSnapshot _nexStatsCoingeco = Main.nexStatsCoingecko;
  QuerySnapshot _transactionsList = Main.nashStakingTransactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _nexStakingContractSection(
            _nexStakingContract, _nexStatsCoingeco, context),
        _biggestStakingTransactionSection(_transactionsList),
        _changeInStakingSection(_transactionsList)
      ],
    );
  }

  Widget _nexStakingContractSection(
      dynamic snapshot, dynamic snapshot2, BuildContext context) {
    return BoxWithLogoWidget(
        "Staking",
        Column(
          children: [
            Text(
                "${(snapshot["balance"][0]["amount"] / snapshot2["market_data"]["circulating_supply"] * 100).toStringAsFixed(2)}%",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "${CalculateNumbers.doubleInRightFormat(snapshot["balance"][0]["amount"].toStringAsFixed(0))} / ${CalculateNumbers.doubleInRightFormat(snapshot2["market_data"]["circulating_supply"].toStringAsFixed(0))} NEX Staked",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
        Icons.account_balance,
        topRight: Button1Widget(
            "Calculator",
            () => Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => StakingCalculatorView()))));
  }

  Widget _biggestStakingTransactionSection(dynamic snapshot) {
    return BoxPremadeWidget(
      "Biggest Staking Transactions",
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _biggestStakingColumn(
                _transactions(1, snapshot, amountOfTransactionsToReturn: 5),
                "24hr"),
            _biggestStakingColumn(
                _transactions(7, snapshot, amountOfTransactionsToReturn: 5),
                "Week"),
            _biggestStakingColumn(
                _transactions(30, snapshot, amountOfTransactionsToReturn: 5),
                "Month"),
          ],
        )
      ],
      color: Colors.grey[50],
    );
  }

  Widget _changeInStakingSection(QuerySnapshot snapshot) {
    // day
    int amount24hrUp = 0;
    int amount24hrDown = 0;
    _transactions(1, snapshot).forEach((transaction) {
      if (transaction["address_to"] == _addresse) {
        amount24hrUp += int.parse(transaction["amount"]);
      } else {
        amount24hrDown += int.parse(transaction["amount"]);
      }
    });

    // month
    int amount7daysUp = 0;
    int amount7daysDown = 0;
    _transactions(7, snapshot).forEach((transaction) {
      if (transaction["address_to"] == _addresse) {
        amount7daysUp += int.parse(transaction["amount"]);
      } else {
        amount7daysDown += int.parse(transaction["amount"]);
      }
    });

    // year
    int amount30daysUp = 0;
    int amount30daysDown = 0;
    _transactions(
            DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month),
            snapshot)
        .forEach((transaction) {
      if (transaction["address_to"] == _addresse) {
        amount30daysUp += int.parse(transaction["amount"]);
      } else {
        amount30daysDown += int.parse(transaction["amount"]);
      }
    });

    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: BoxPremadeWidget(
          "Staking Changes",
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _changeInStakingColumn("24hr", amount24hrUp, amount24hrDown),
                _changeInStakingColumn("Week", amount7daysUp, amount7daysDown),
                _changeInStakingColumn(
                    "Month", amount30daysUp, amount30daysDown),
              ],
            )
          ],
          color: Colors.grey[50],
        ));
  }

  List<dynamic> _transactions(int days, QuerySnapshot transactions,
      {int amountOfTransactionsToReturn}) {
    int time;
    List<dynamic> _transactions = [];
    bool crossedLimit = false;

    // we go through each document
    for (var document in transactions.docs) {
      Map<String, dynamic> data = document.data();

      if (crossedLimit) {
        break;
      }

      if (time == null) {
        time = (data["1"]["entries"][1]["time"] - (86400 * days));
      }

      // we go through each pageBundle
      for (int i = 1; i <= 50; i++) {
        if (crossedLimit) {
          break;
        }
        // we go through each transaction
        for (var transaction in data[i.toString()]["entries"]) {
          if (crossedLimit) {
            break;
          }

          if (transaction["time"] > time) {
            _transactions.add(transaction);
          } else {
            crossedLimit = true;
            break;
          }
        }
      }
    }

    // sort transactions
    _transactions.sort(
        (a, b) => int.parse(b["amount"]).compareTo(int.parse(a["amount"])));

    // cut the amount of transactions to return if specified
    if (amountOfTransactionsToReturn != null) {
      if (_transactions.sublist(0, amountOfTransactionsToReturn).length >=
          amountOfTransactionsToReturn) {
        _transactions = _transactions.sublist(0, amountOfTransactionsToReturn);
      } else {
        _transactions = _transactions;
      }
    }

    return _transactions;
  }

  Widget _changeInStakingColumn(String title, int up, int down) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: 113,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("+ ${CalculateNumbers.doubleInRightFormat(up.toString())}",
                  style:
                      TextStyle(fontSize: 14, color: Colors.greenAccent[700])),
              Text(
                  " - ${CalculateNumbers.doubleInRightFormat(down.toString())}",
                  style: TextStyle(fontSize: 14, color: Colors.redAccent[700])),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "=",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text(
                (up - down) > 0
                    ? "+ ${CalculateNumbers.doubleInRightFormat((up - down).toString())}"
                    : "- ${CalculateNumbers.doubleInRightFormat((up - down).abs().toString())}",
                style: TextStyle(
                    fontSize: 14,
                    color: (up - down) > 0
                        ? Colors.greenAccent[700]
                        : Colors.redAccent[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _biggestStakingColumn(List<dynamic> transactions, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.black87)),
        ...transactions.map((transaction) {
          return Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Container(
              width: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: transaction["address_to"] == _addresse
                      ? Colors.greenAccent[700]
                      : Colors.redAccent[700]),
              child: Text(
                CalculateNumbers.doubleInRightFormat(transaction["amount"]),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }).toList()
      ],
    );
  }
}
