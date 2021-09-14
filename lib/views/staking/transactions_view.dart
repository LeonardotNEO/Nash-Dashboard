import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';

class TransactionView extends StatefulWidget {
  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final String _addresse = "ALuZLuuDssJqG2E4foANKwbLamYHuffFjg";
  int _transactionsPerPage = 10;
  int _page = 1;
  int _pageLimit = 50;
  List _transactionsListAll = [];
  List _transactionsToShow = [];

  @override
  void initState() {
    super.initState();

    _transactionsListAll = _transactions(Main.nashStakingTransactions);
    _transactionsToShow = _transactionsListAll.sublist(0, 10);
    _pageLimit = (_transactions(Main.nashStakingTransactions).length /
            _transactionsPerPage)
        .round();
  }

  void _updatePage(int increment) {
    setState(() {
      if (_page + increment <= _pageLimit && _page + increment > 0) {
        _page += increment;
        _transactionsToShow = _transactionsListAll.sublist(
            (_page - 1) * _transactionsPerPage, _page * _transactionsPerPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    _transactionsToShow.forEach((element) {
      int time = element["time"];

      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            width: double.infinity,
            padding: EdgeInsets.all(5),
            child: element["address_to"] == _addresse
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(time * 1000)
                            .toString()
                            .split(".")[0],
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 80,
                            child: Text(element["amount"],
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.greenAccent[700])),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.greenAccent[700],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 280,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent[700],
                                  borderRadius: BorderRadius.circular(7)),
                              padding: EdgeInsets.all(3),
                              child: Text(
                                "Nash staking",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(time * 1000)
                            .toString()
                            .split(".")[0],
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 80,
                            child: Text(
                              element["amount"],
                              style: TextStyle(
                                  fontSize: 17, color: Colors.redAccent[700]),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.redAccent[700],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 280,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.redAccent[700],
                                  borderRadius: BorderRadius.circular(7)),
                              padding: EdgeInsets.all(3),
                              child: Text(
                                element["address_to"],
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
      ));
    });

    return Column(
      children: [_swapPage(), ...widgets],
    );
  }

  Widget _swapPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => _updatePage(-1),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
            IconButton(
              onPressed: () => _updatePage(-10),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () => _updatePage(-100),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
          decoration: BoxDecoration(
              color: Main.color[900], borderRadius: BorderRadius.circular(5)),
          child: Text(
            _page.toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _updatePage(100),
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () => _updatePage(10),
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            IconButton(
                onPressed: () => _updatePage(1),
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )),
          ],
        ),
      ],
    );
  }

  List<dynamic> _transactions(QuerySnapshot transactions) {
    List<dynamic> _transactions = [];

    // we go through each document
    for (var document in transactions.docs) {
      Map<String, dynamic> data = document.data();

      // we go through each pageBundle
      for (int i = 1; i <= 50; i++) {
        // we go through each transaction
        for (var transaction in data[i.toString()]["entries"]) {
          _transactions.add(transaction);
        }
      }
    }

    // sort transactions
    _transactions
        .sort((a, b) => (b["time"] as int).compareTo(a["time"] as int));

    return _transactions;
  }
}
