import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/utils/calculate_numbers.dart';
import 'package:nash_dashboard/widgets/box_change_widget.dart';
import 'package:nash_dashboard/widgets/box_premade_widget.dart';
import 'package:nash_dashboard/widgets/box_withlogo_widget.dart';

class NexView extends StatefulWidget {
  DocumentSnapshot _nexStatsCoingecko = Main.nexStatsCoingecko;
  DocumentSnapshot _nexStatsCMC = Main.nexStatsCMC;

  @override
  _NexViewState createState() => _NexViewState();
}

class _NexViewState extends State<NexView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _nexLogo(widget._nexStatsCoingecko),
        _nexGeneralStats(widget._nexStatsCMC),
        _priceChange(widget._nexStatsCMC, widget._nexStatsCoingecko),
        _priceChangeMore(widget._nexStatsCoingecko, widget._nexStatsCMC),
      ],
    );
  }
}

Widget _nexLogo(DocumentSnapshot snapshot) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Container(
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: Main.color[900], borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    child: Image.network(
                      snapshot["image"]["large"],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "${snapshot["name"]} dashboard",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    ),
  );
}

Widget _nexGeneralStats(DocumentSnapshot snapshot) {
  return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        child: Stack(children: [_marketcapRank(snapshot)]),
      ));
}

Widget _marketcapRank(DocumentSnapshot snapshot) {
  return Container(
      decoration: BoxDecoration(
          color: Main.color[900],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
      child: Column(
        children: [
          _marketCapRankRow(
              "Marketcap",
              "${CalculateNumbers.doubleInRightFormat(((snapshot["data"]["NEX"]["quote"]["USD"]["price"] as double) * (snapshot["data"]["NEX"]["circulating_supply"] as int)).toStringAsFixed(0))}\$",
              Icons.savings_rounded),
          _marketCapRankRow("Rank", "#${snapshot["data"]["NEX"]["cmc_rank"]}",
              Icons.bar_chart)
        ],
      ));
}

Widget _marketCapRankRow(String title, String data, IconData icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(title,
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Container(
          child: Text(
            data,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}

Widget _priceChange(DocumentSnapshot cmc, DocumentSnapshot coingecko) {
  double nexPriceEur = (cmc["data"]["NEX"]["quote"]["USD"]["price"] as double) /
      (Main.tokens["tokens"][11]["current_price"] as double);
  double nexPriceBtc = (cmc["data"]["NEX"]["quote"]["USD"]["price"] as double) /
      Main.tokens["tokens"][0]["current_price"] *
      100000000;

  return Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Container(
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 30),
      decoration: BoxDecoration(
          color: Main.color[900],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                "Change (24hr)",
                style: TextStyle(fontSize: 16, color: Colors.white),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: 150,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${(cmc["data"]["NEX"]["quote"]["USD"]["price"]).toStringAsFixed(2)}",
                            style:
                                TextStyle(fontSize: 20, color: Main.color[900]),
                          ),
                          Icon(
                            Icons.attach_money,
                            size: 25,
                            color: Main.color[900],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${nexPriceEur.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 20, color: Main.color[900]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                Icons.euro,
                                size: 20,
                                color: Main.color[900],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${nexPriceBtc.toStringAsFixed(0)}",
                              style: TextStyle(
                                  fontSize: 20, color: Main.color[900]),
                            ),
                            Text(
                              "Sats",
                              style: TextStyle(
                                  fontSize: 18, color: Main.color[900]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${(cmc["data"]["NEX"]["quote"]["USD"]["percent_change_24h"] as double).toStringAsFixed(2)}\%",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 45,
                    color: cmc["data"]["NEX"]["quote"]["USD"]
                                ["percent_change_24h"]
                            .toString()
                            .contains("-")
                        ? Colors.redAccent[400]
                        : Colors.greenAccent[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _priceChangeMore(DocumentSnapshot coingecko, DocumentSnapshot cmc) {
  return BoxPremadeWidget(
    "Change",
    [
      Row(children: [
        BoxChangeWidget(
          "7d",
          "${cmc["data"]["NEX"]["quote"]["USD"]["percent_change_7d"].toStringAsFixed(2)}\%",
          cmc["data"]["NEX"]["quote"]["USD"]["percent_change_7d"]
              .toString()
              .contains("-"),
          color: Colors.grey[200],
        ),
        BoxChangeWidget(
          "30d",
          "${cmc["data"]["NEX"]["quote"]["USD"]["percent_change_30d"].toStringAsFixed(2)}\%",
          cmc["data"]["NEX"]["quote"]["USD"]["percent_change_30d"]
              .toString()
              .contains("-"),
          color: Colors.grey[200],
        ),
        BoxChangeWidget(
          "200d",
          "${coingecko["market_data"]["price_change_percentage_200d"].toStringAsFixed(2)}\%",
          coingecko["market_data"]["price_change_percentage_200d"]
              .toString()
              .contains("-"),
          color: Colors.grey[200],
        ),
        BoxChangeWidget(
          "1y",
          "${coingecko["market_data"]["price_change_percentage_1y"].toStringAsFixed(2)}\%",
          coingecko["market_data"]["price_change_percentage_1y"]
              .toString()
              .contains("-"),
          color: Colors.grey[200],
        )
      ])
    ],
    color: Colors.grey[50],
  );
}
