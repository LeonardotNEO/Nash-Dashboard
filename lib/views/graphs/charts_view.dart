import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/utils/calculate_numbers.dart';
import 'package:nash_dashboard/views/graphs/data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ChartData> nexStakedOverTime = _nexStakedOverTimeDoraFormated();
    List<ChartData> nexEarningsApyOverTime = _nexApyOverTimeFormated();
    List<ChartData> earningsContractSizeOverTime =
        _earningsContractSizeFormated();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          _chart(nexStakedOverTime, "Nex staked", DateFormat.yMMM()),
          _chart(
              nexEarningsApyOverTime, "Nash Earnings APY", DateFormat.MMMd()),
          _chart(earningsContractSizeOverTime,
              "Nash Earnings Contract Size (\$)", DateFormat.MMMd())
        ]),
      ),
    );
  }

  Widget _chartContainer(String title, SfCartesianChart chart) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Main.color[900]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            chart,
          ],
        ),
      ),
    );
  }

  Widget _chart(List<ChartData> dataList, String title, DateFormat format) {
    return _chartContainer(
        title,
        SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: format,
              labelStyle: TextStyle(color: Colors.white),
            ),
            primaryYAxis:
                NumericAxis(labelStyle: TextStyle(color: Colors.white)),
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<ChartData, DateTime>(
                color: Colors.white,
                dataSource: dataList,
                xValueMapper: (ChartData data, _) =>
                    DateTime.fromMillisecondsSinceEpoch(data.getX()),
                yValueMapper: (ChartData data, _) => data.getY(),
              )
            ]));
  }

  List<ChartData> _nexStakedOverTimeDoraFormated() {
    List<ChartData> list = [];
    (Main.nexStakingHistory["history"][0]["balances"] as List)
        .forEach((element) {
      int dateTimestamp =
          DateTime.parse(element["date"]).millisecondsSinceEpoch;
      int balance = int.parse(CalculateNumbers.removeTrailingZeros(
          element["balance"].toString(), dateTimestamp));

      list.add(ChartData(dateTimestamp, balance));
    });

    return list;
  }

  List<ChartData> _nexApyOverTimeFormated() {
    List<ChartData> list = [];
    (Main.nashEarningsAPYOverTime["timestamps"] as List).forEach((element) {
      ChartData data = ChartData(element["timestamp"] * 1000,
          double.parse(double.parse(element["apy"]).toStringAsFixed(2)));
      list.add(data);
    });

    return list;
  }

  List<ChartData> _earningsContractSizeFormated() {
    List<ChartData> list = [];
    (Main.earningsContractSizeOverTime["timestamps"] as List)
        .forEach((element) {
      ChartData data = ChartData(int.parse(element["timestamp"]) * 1000,
          double.parse((element["valueLocked"] as double).toStringAsFixed(2)));
      list.add(data);
    });

    return list;
  }
}
