class IntervalClass {
  late double min;
  late double max;
  late double freq = 0.0;
  late int countSample = 0;

  IntervalClass({required this.min, required this.max});

  @override
  String toString() {
    return '(${min.toStringAsFixed(2)};${max.toStringAsFixed(2)}]';
  }
}
