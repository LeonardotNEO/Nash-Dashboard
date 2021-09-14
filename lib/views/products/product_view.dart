import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/views/products/L2_exchange_view.dart';
import 'package:nash_dashboard/views/products/earnings_view.dart';
import 'package:nash_dashboard/views/products/fiat_ramp_view.dart';
import 'package:nash_dashboard/views/products/nash_cash_view.dart';
import 'package:nash_dashboard/views/products/nash_link_view.dart';

class ProductView extends StatefulWidget {
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: _tabBar(),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TabBarView(controller: _controller, children: [
              ListView(
                children: [
                  EarningsView(),
                ],
              ),
              ListView(
                children: [
                  FiatRampView(),
                ],
              ),
              /*
              ListView(
                children: [
                  NashLinkView(),
                ],
              ),*/
              ListView(
                children: [
                  L2ExchangeView(),
                ],
              ),
            ]),
          )),
    );
  }

  Widget _tabBar() {
    return TabBar(controller: _controller, tabs: [
      Tab(
          icon: Icon(
            Icons.euro,
            color: Main.color[900],
            size: 20,
          ),
          child: Text(
            "Earnings",
            style: TextStyle(color: Main.color[900], fontSize: 12),
          )),
      Tab(
          icon: Icon(
            CryptoFontIcons.BTC,
            color: Main.color[900],
            size: 20,
          ),
          child: Text(
            "Fiat Ramp",
            style: TextStyle(color: Main.color[900], fontSize: 12),
          )),
      /*Tab(
          icon: Icon(
            Icons.payments,
            color: Main.color[900],
            size: 20,
          ),
          child: Text(
            "Nash Link",
            style: TextStyle(color: Main.color[900], fontSize: 12),
          )),*/
      Tab(
          icon: Icon(
            Icons.swap_horiz,
            color: Main.color[900],
            size: 20,
          ),
          child: Text(
            "L2 Exchange",
            style: TextStyle(color: Main.color[900], fontSize: 10),
          )),
    ]);
  }
}
