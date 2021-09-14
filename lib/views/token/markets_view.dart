import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/utils/calculate_numbers.dart';
import 'package:nash_dashboard/widgets/box_change_widget.dart';
import 'package:nash_dashboard/widgets/box_premade_widget.dart';
import 'package:nash_dashboard/widgets/box_withlogo_widget.dart';

class MarketsView extends StatefulWidget {
  DocumentSnapshot _nexStatsCoingecko = Main.nexStatsCoingecko;

  @override
  _MarketsViewState createState() => _MarketsViewState();
}

class _MarketsViewState extends State<MarketsView> {
  // TOKOK
  double tokokNexEthPrice;
  double tokokNexEthVolume;
  double tokokNexBtcPrice;
  double tokokNexBtcVolume;
  double tokokNexTotalVolume;
  // UNISWAP
  double uniswapNexUsdc10Price;
  double uniswapNexUsdc10Volume;
  double uniswapNexUsdc03Price;
  double uniswapNexUsdc03Volume;
  double uniswapNexEth03Price;
  double uniswapNexEth03Volume;
  double uniswapNexTotalVolume;
  // DEMEX
  double demexNexUsdcPrice;
  double demexNexUsdcVolume;

  // ALL
  double totalVolume;

  Image eth = Image.network(
      "https://assets.coingecko.com/coins/images/279/small/ethereum.png?1595348880");
  Image btc = Image.network(
      "https://assets.coingecko.com/coins/images/1/small/bitcoin.png?1547033579");
  Image usdc = Image.network(
      "https://assets.coingecko.com/coins/images/6319/small/USD_Coin_icon.png?1547042389");
  Image nex = Image.network(
      "https://assets.coingecko.com/coins/images/3246/large/Nash-token_icon.png?1550821163");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // TOKOK
    tokokNexEthPrice =
        (double.parse(Main.nexStatsTokok["nex_eth"]["ticker"]["last"]) *
            Main.tokens["tokens"][1]["current_price"]);
    tokokNexEthVolume =
        double.parse(Main.nexStatsTokok["nex_eth"]["ticker"]["vol"]) *
            tokokNexEthPrice;
    tokokNexBtcPrice =
        double.parse(Main.nexStatsTokok["nex_btc"]["ticker"]["last"]) *
            Main.tokens["tokens"][0]["current_price"];
    tokokNexBtcVolume =
        double.parse(Main.nexStatsTokok["nex_btc"]["ticker"]["vol"]) *
            tokokNexBtcPrice;
    tokokNexTotalVolume = tokokNexEthVolume + tokokNexBtcVolume;

    // UNSWAP
    uniswapNexUsdc10Price = double.parse(
        Main.nexStatsUniswap["NEXUSDCPOOL1"]["poolDayData"][0]["token0Price"]);
    uniswapNexUsdc10Volume = double.parse(
        Main.nexStatsUniswap["NEXUSDCPOOL1"]["poolHourData"][0]["volumeUSD"]);
    uniswapNexUsdc03Price = double.parse(
        Main.nexStatsUniswap["NEXUSDCPOOL03"]["poolDayData"][0]["token0Price"]);

    uniswapNexUsdc03Volume = double.parse(
        Main.nexStatsUniswap["NEXUSDCPOOL03"]["poolDayData"][0]["volumeUSD"]);
    uniswapNexEth03Price = double.parse(
        Main.nexStatsUniswap["NEXETHPOOL03"]["poolDayData"][0]["token0Price"]);
    uniswapNexEth03Volume = double.parse(
        Main.nexStatsUniswap["NEXETHPOOL03"]["poolHourData"][0]["volumeUSD"]);
    uniswapNexTotalVolume =
        uniswapNexUsdc10Volume + uniswapNexUsdc03Volume + uniswapNexEth03Volume;

    // DEMEX
    /*demexNexUsdcPrice =
        (double.parse(Main.nexStatsTokok["nex_eth"]["ticker"]["last"]) *
            Main.tokens["tokens"][1]["current_price"]);*/

    // ALL
    totalVolume = tokokNexTotalVolume + uniswapNexTotalVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _totalVolumeAllMarkets(),
      _volume(widget._nexStatsCoingecko),
      _marketBox(
          "Markets",
          [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Exchange", style: TextStyle(fontSize: 12)),
                  Text("Volume", style: TextStyle(fontSize: 12)),
                  Text("Price", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            _individualExchangeBox(
                "Uniswap 1.0%",
                uniswapNexUsdc10Volume.toStringAsFixed(2) + "\$",
                uniswapNexUsdc10Price.toStringAsFixed(2) + "\$",
                usdc),
            _individualExchangeBox(
                "Uniswap 0.3%",
                uniswapNexUsdc03Volume.toStringAsFixed(2) + "\$",
                uniswapNexUsdc03Price.toStringAsFixed(2) + "\$",
                usdc),
            _individualExchangeBox(
                "Uniswap 0.3%",
                uniswapNexEth03Volume.toStringAsFixed(2) + "\$",
                uniswapNexEth03Price.toStringAsFixed(2) + "\$",
                eth),
            _individualExchangeBox(
                "Tokok",
                CalculateNumbers.doubleInRightFormat(
                        tokokNexEthVolume.toStringAsFixed(0)) +
                    "\$",
                tokokNexEthPrice.toStringAsFixed(2) + "\$",
                eth),
            _individualExchangeBox(
                "Tokok",
                CalculateNumbers.doubleInRightFormat(
                        tokokNexBtcVolume.toStringAsFixed(0)) +
                    "\$",
                tokokNexBtcPrice.toStringAsFixed(2) + "\$",
                btc),
          ],
          nex)
    ]);
  }

  Widget _totalVolumeAllMarkets() {
    return BoxWithLogoWidget(
        "Total Volume Nex Markets",
        Text(
          CalculateNumbers.doubleInRightFormat(totalVolume.toStringAsFixed(0)) +
              "\$",
          style: TextStyle(color: Colors.white, fontSize: 35),
        ),
        Icons.store);
  }

  Widget _volume(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: BoxPremadeWidget(
        "Volume",
        [
          Row(
            children: [
              BoxChangeWidget(
                "Uniswap",
                "${CalculateNumbers.doubleInRightFormat(uniswapNexTotalVolume.toStringAsFixed(0))}\$",
                snapshot["market_data"]["price_change_percentage_7d"]
                    .toString()
                    .contains("-"),
                color: Colors.grey[200],
              ),
              BoxChangeWidget(
                "Tokok",
                "${CalculateNumbers.doubleInRightFormat(tokokNexTotalVolume.toStringAsFixed(0))}\$",
                snapshot["market_data"]["price_change_percentage_7d"]
                    .toString()
                    .contains("-"),
                color: Colors.grey[200],
              ),
            ],
          ),
          /*
          Row(
            children: [
              
              BoxChangeWidget(
                "Demex",
                "${snapshot["market_data"]["total_volume"]["usd"].toStringAsFixed(2)}\$",
                snapshot["market_data"]["price_change_percentage_7d"]
                    .toString()
                    .contains("-"),
                color: Colors.grey[200],
              ),
              BoxChangeWidget(
                "1inch",
                "${snapshot["market_data"]["total_volume"]["usd"].toStringAsFixed(2)}\$",
                snapshot["market_data"]["price_change_percentage_7d"]
                    .toString()
                    .contains("-"),
                color: Colors.grey[200],
              ),
            ],
          ),
          */
        ],
        color: Colors.grey[50],
      ),
    );
  }

  Widget _marketBox(String marketName, List<Widget> exchanges, Image image) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: BoxPremadeWidget(
        marketName,
        [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [...exchanges],
            ),
          )
        ],
        right: Container(
          height: 30,
          width: 30,
          child: image,
        ),
        color: Colors.grey[50],
      ),
    );
  }

  Widget _individualExchangeBox(
      String exchangeTitle, String price, String volume, Image image) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(height: 25, width: 25, child: image),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(exchangeTitle,
                            style: TextStyle(fontSize: 12)))),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          price,
                          style: TextStyle(fontSize: 12),
                        ))),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(volume, style: TextStyle(fontSize: 12)))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
