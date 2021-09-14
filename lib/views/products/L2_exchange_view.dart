import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/utils/calculate_numbers.dart';
import 'package:nash_dashboard/widgets/box_change_widget.dart';
import 'package:nash_dashboard/widgets/box_premade_widget.dart';
import 'package:nash_dashboard/widgets/box_withlogo_widget.dart';

class L2ExchangeView extends StatefulWidget {
  DocumentSnapshot _nexL2Stats = Main.nashL2Stats;

  @override
  _L2ExchangeViewState createState() => _L2ExchangeViewState();
}

class _L2ExchangeViewState extends State<L2ExchangeView> {
  var tokenListInOrder;
  double volume1hr = 0;
  double volume24hr = 0;
  double volume7day = 0;
  double volume1month = 0;

  @override
  void initState() {
    super.initState();

    // get total volume of all markets
    double volume1hrCounter = 0;
    for (Map<String, dynamic> volume in (widget._nexL2Stats["hour"] as List)) {
      volume1hrCounter += double.parse(volume["volumeUsd"]["amount"]);
    }
    volume1hr = volume1hrCounter;

    double volume24hrCounter = 0;
    for (Map<String, dynamic> volume in (widget._nexL2Stats["day"] as List)) {
      volume24hrCounter += double.parse(volume["volumeUsd"]["amount"]);
    }
    volume24hr = volume24hrCounter;

    double volumeWeekCounter = 0;
    for (Map<String, dynamic> volume in (widget._nexL2Stats["week"] as List)) {
      volumeWeekCounter += double.parse(volume["volumeUsd"]["amount"]);
    }
    volume7day = volumeWeekCounter;

    double volumeMonthCounter = 0;
    for (Map<String, dynamic> volume in (widget._nexL2Stats["month"] as List)) {
      volumeMonthCounter += double.parse(volume["volumeUsd"]["amount"]);
    }
    volume1month = volumeMonthCounter;

    // sort markets by volume
    tokenListInOrder = widget._nexL2Stats["day"] as List;
    tokenListInOrder.sort((a, b) => double.parse(b["volumeUsd"]["amount"])
        .compareTo(double.parse(a["volumeUsd"]["amount"])));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _volumeBox(),
        _volumeBoxMore(),
        _markets(),
        _exchangeComparison()
      ],
    );
  }

  Widget _volumeBox() {
    return BoxWithLogoWidget(
        "Volume (24hr)",
        Text(
          "${CalculateNumbers.doubleInRightFormat(volume24hr.toStringAsFixed(0))}\$",
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        Icons.swap_horiz);
  }

  Widget _volumeBoxMore() {
    return BoxPremadeWidget(
      "Volume",
      [
        Row(
          children: [
            BoxChangeWidget(
                "Hour",
                CalculateNumbers.doubleInRightFormat(
                        volume1hr.toStringAsFixed(0)) +
                    "\$",
                false),
            BoxChangeWidget(
                "Week",
                CalculateNumbers.doubleInRightFormat(
                        volume7day.toStringAsFixed(0)) +
                    "\$",
                false),
            BoxChangeWidget(
                "Month",
                CalculateNumbers.doubleInRightFormat(
                        volume1month.toStringAsFixed(0)) +
                    "\$",
                false),
          ],
        ),
      ],
      padding: EdgeInsets.all(10),
    );
  }

  Widget _markets() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: BoxPremadeWidget(
        "Markets",
        [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _marketRowField("Pair")),
                      Expanded(child: _marketRowField("Volume", right: true)),
                      Expanded(
                        child: _marketRowField("Change", right: true),
                      ),
                      Expanded(child: _marketRowField("Price", right: true)),
                    ],
                  ),
                ),
                ...(tokenListInOrder as List)
                    .map((e) => _marketRow(e))
                    .toList(),
              ],
            ),
          ),
        ],
        color: Colors.grey[50],
      ),
    );
  }

  Widget _marketRow(dynamic market) {
    Image imageAssetA;
    Image imageAssetB;
    for (dynamic token in Main.tokens["tokens"]) {
      if (market["market"]["aAsset"]["symbol"] == token["symbol"]) {
        imageAssetA = Image.network(
          token["image"],
          height: 25,
          width: 25,
        );
      }
      if (market["market"]["bAsset"]["symbol"] == token["symbol"]) {
        imageAssetB = Image.network(
          token["image"],
          height: 25,
          width: 25,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  imageAssetA,
                  imageAssetB,
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _marketRowField(
                          market["market"]["aAsset"]["symbol"]
                              .toString()
                              .toUpperCase(),
                          color: Colors.black87,
                        ),
                        _marketRowField(
                          market["market"]["bAsset"]["symbol"]
                              .toString()
                              .toUpperCase(),
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _marketRowField(
                  "${CalculateNumbers.doubleInRightFormat(double.parse(market["volumeUsd"]["amount"]).toStringAsFixed(0))}\$",
                  color: Colors.black87,
                  right: true),
            ),
            Expanded(
              child: _marketRowField(
                  (market["priceChangePercent"] * 100).toStringAsFixed(2) +
                      " %",
                  color: market["priceChangePercent"] >= 0
                      ? market["priceChangePercent"] == 0
                          ? Colors.black87
                          : Colors.greenAccent[700]
                      : Colors.redAccent[700],
                  right: true),
            ),
            Expanded(
              child: _marketRowField(
                  "${double.parse(market["bestBidPrice"]["amount"]).toStringAsFixed(2)}",
                  color: Colors.black87,
                  right: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _marketRowField(
    String string, {
    Color color,
    bool right,
    double width,
  }) {
    return Container(
        alignment: right != null ? Alignment.centerRight : Alignment.centerLeft,
        width: width,
        child: Text(
          string,
          style: TextStyle(
              color: color == null ? Colors.black87 : color, fontSize: 12),
        ));
  }

  Widget _exchangeComparison() {
    DocumentSnapshot exchanges = Main.exchangeData;
    int exchangeNumber = 0;
    double btcPrice;
    for (dynamic asset in Main.nashL2Stats["day"]) {
      if (asset["market"]["aAsset"]["symbol"] == "btc") {
        btcPrice = double.parse(asset["bestBidPrice"]["amount"]);
      }
    }

    List<Widget> list =
        (exchanges["exchanges"] as List).getRange(0, 9).map((e) {
      exchangeNumber++;
      String volume =
          ((e["trade_volume_24h_btc_normalized"] as double) * btcPrice)
              .toStringAsFixed(0);
      return _exchangeRow(e, volume, rank: exchangeNumber);
    }).toList();

    list.add(_exchangeRow(
        {"name": "Nash exchange"}, volume24hr.toStringAsFixed(0),
        image: Main.nexStatsCoingecko["image"]["small"]));

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: BoxPremadeWidget(
        "Exchanges comparison (24hr volume)",
        [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _marketRowField("Name"),
                _marketRowField("24hr Volume", right: true),
              ],
            ),
          ),
          ...list
        ],
        color: Colors.grey[50],
      ),
    );
  }

  Widget _exchangeRow(dynamic exchange, String volume,
      {int rank, String image}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            image,
                            height: 25,
                            width: 25,
                          ))
                      : exchange["image"] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                exchange["image"],
                                height: 25,
                                width: 25,
                              ))
                          : SizedBox.shrink(),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(exchange["name"],
                          style: TextStyle(fontSize: 12))),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  CalculateNumbers.doubleInRightFormat(volume) + "\$",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
