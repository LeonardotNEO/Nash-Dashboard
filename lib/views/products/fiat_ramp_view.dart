import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/widgets/box_premade_widget.dart';

class FiatRampView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _feeBox(),
        _availableCrypto(),
      ],
    );
  }

  Widget _feeBox() {
    return BoxPremadeWidget(
      "Fee",
      [
        Center(
          child: Text(
            Main.nashFiatRampStats["fiatRampRatesAndAssets"][0]["nashFee"] +
                "%",
            style: TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
      ],
      padding: EdgeInsets.all(10),
    );
  }

  Widget _availableCrypto() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BoxPremadeWidget(
        "Cryptocurrencies",
        [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Container(
                    width: 150,
                    child: Text(
                      "Symbol",
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    child: Center(
                        child: Text(
                  "Buy",
                  style: TextStyle(fontSize: 12),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  "Sell",
                  style: TextStyle(fontSize: 12),
                ))),
                Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: Text(
                      "Spread",
                      style: TextStyle(fontSize: 12),
                    ))
              ],
            ),
          ),
          ...(Main.nashFiatRampStats["fiatRampRatesAndAssets"] as List)
              .map((token) {
            if (token["saleFiatPrice"] == null ||
                token["purchaseFiatPrice"] == null) return SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]),
                child: _cryptoCurrenciesRow(token),
              ),
            );
          }).toList()
        ],
        color: Colors.grey[50],
      ),
    );
  }

  Widget _cryptoCurrenciesRow(dynamic token) {
    Image image;
    (Main.tokens["tokens"] as List).forEach((tokenCoingecko) {
      if (tokenCoingecko["symbol"].toString().toLowerCase() ==
          token["symbol"].toString().toLowerCase()) {
        image = Image.network(tokenCoingecko["image"]);
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 150,
          child: Row(
            children: [
              image != null
                  ? Container(height: 25, width: 25, child: image)
                  : SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  token["symbol"].toString().toUpperCase(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _sellBuyBox(
              double.parse(token["purchaseFiatPrice"]["price"]["amount"])
                  .toStringAsFixed(2),
              true),
        ),
        Expanded(
          child: _sellBuyBox(
              double.parse(token["saleFiatPrice"]["price"]["amount"])
                  .toStringAsFixed(2),
              false),
        ),
        Container(
          width: 50,
          alignment: Alignment.centerRight,
          child: Text(
            ((double.parse(token["purchaseFiatPrice"]["price"]["amount"]) -
                            double.parse(
                                token["saleFiatPrice"]["price"]["amount"])) /
                        double.parse(
                            token["purchaseFiatPrice"]["price"]["amount"]) *
                        100)
                    .toStringAsFixed(2) +
                "%",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _sellBuyBox(String title, bool buy) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buy ? Colors.greenAccent[700] : Colors.redAccent[700],
        ),
        padding: EdgeInsets.all(5),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
