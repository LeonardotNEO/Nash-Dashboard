import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/views/staking/overview_view.dart';
import 'package:nash_dashboard/views/staking/top_staker_view.dart';
import 'package:nash_dashboard/views/staking/transactions_view.dart';

class StakingView extends StatefulWidget {
  @override
  _StakingViewState createState() => _StakingViewState();
}

class _StakingViewState extends State<StakingView>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
              children: [OverViewView()],
            ),
            ListView(
              children: [TransactionView()],
            ),
            ListView(
              children: [TopStakerView()],
            ),
          ]),
        ));
  }

  Widget _tabBar() {
    return TabBar(controller: _controller, tabs: [
      Tab(
        icon: Icon(
          Icons.account_balance,
          color: Main.color[900],
          size: 20,
        ),
        child: Text(
          "Staking",
          style: TextStyle(color: Main.color[900], fontSize: 12),
        ),
      ),
      Tab(
        icon: Icon(
          Icons.swap_horiz,
          color: Main.color[900],
          size: 20,
        ),
        child: Text(
          "Transactions",
          style: TextStyle(color: Main.color[900], fontSize: 12),
        ),
      ),
      Tab(
        icon: Icon(
          Icons.military_tech,
          color: Main.color[900],
          size: 20,
        ),
        child: Text(
          "Top stakers",
          style: TextStyle(color: Main.color[900], fontSize: 12),
        ),
      )
    ]);
  }
}
