import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {
  List _list;

  ChartView(this._list);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        //series: LineSeries(dataSource: _list, xValueMapper: xValueMapper, yValueMapper: yValueMapper),
      ),
    );
  }
}
