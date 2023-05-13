import 'package:charts_flutter/flutter.dart' as charts;

class BarModel {
  final String n;
  final double freq;
  final charts.Color color;

  BarModel({required this.n, required this.freq, required this.color});
}