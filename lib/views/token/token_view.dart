import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/views/token/info_view.dart';
import 'package:nash_dashboard/views/token/markets_view.dart';
import 'package:nash_dashboard/views/token/nex_view.dart';

class TokenView extends StatefulWidget {
  @override
  _TokenViewState createState() => _TokenViewState();
}

class _TokenViewState extends State<TokenView> with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Main.pullReferesh(),
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
              physics: BouncingScrollPhysics(),
              children: [
                NexView(),
              ],
            ),
            ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [MarketsView()]),
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [InfoView()],
            )
          ]),
        ),
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(controller: _controller, tabs: [
      Tab(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 17,
            height: 17,
            child: Image.network(Main.nexStatsCoingecko["image"]["small"]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Text(
              "NEX",
              style: TextStyle(color: Main.color[900], fontSize: 12),
            ),
          )
        ],
      )),
      Tab(
          icon: Icon(
            Icons.store,
            color: Main.color[900],
            size: 20,
          ),
          child: Text(
            "Markets",
            style: TextStyle(color: Main.color[900], fontSize: 12),
          )),
      Tab(
          icon: Icon(
            Icons.help_outline,
            color: Main.color[900],
            size: 20,
          ),
          child: Text(
            "Info",
            style: TextStyle(color: Main.color[900], fontSize: 12),
          ))
    ]);
  }
}
