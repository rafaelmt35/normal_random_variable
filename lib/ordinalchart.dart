import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OrdinalComboBarLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  const OrdinalComboBarLineChart(this.seriesList, {super.key, required this.animate});

  factory OrdinalComboBarLineChart.withSampleData(
      List<Series<dynamic, String>> seriesList) {
    return OrdinalComboBarLineChart(
      seriesList,
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.OrdinalComboChart(seriesList,
        animate: animate,
        defaultRenderer: charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped),
        customSeriesRenderers: [
          charts.LineRendererConfig(customRendererId: 'customLine')
        ]);
  }
}
