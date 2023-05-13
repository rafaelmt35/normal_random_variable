import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:normal_rand_variable/bar_model.dart';
import 'package:normal_rand_variable/ordinalchart.dart';
import 'dart:math';
import 'dart:math' as math;

import 'interval.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Find Normal Random Variables'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final rnd = Random();
  List<IntervalClass> intervalList = [];
  String chiBool = '';
  double average = 0.0;
  double varnce = 0.0;
  double chisquared = 0.0;
  double empAvg = 0.0;
  double empVar = 0.0;
  double errorVar = 0.0;
  double errorAvg = 0.0;

  @override
  void initState() {
    super.initState();
  }

  final List<BarModel> data = [];

  TextEditingController variancecontroller = TextEditingController();
  TextEditingController meancontroller = TextEditingController();
  TextEditingController ncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double logBase(num x, num base) {
      return log(x) / log(base);
    }

    List<charts.Series<BarModel, String>> seriesStack = [
      charts.Series<BarModel, String>(
          id: 'bar',
          colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
          domainFn: (BarModel series, _) => series.n.toString(),
          measureFn: (BarModel series, _) => series.freq,
          data: data),
      charts.Series<BarModel, String>(
          id: 'line ',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (BarModel series, _) => series.n.toString(),
          measureFn: (BarModel series, _) => series.freq,
          data: data)
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Mean',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5.0),
                    height: 36.0,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: meancontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  const Text(
                    'Variance',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5.0),
                    height: 36.0,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: variancecontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  const Text(
                    'Sample Size',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5.0),
                    height: 36.0,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: ncontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  var mean = double.parse(meancontroller.text);
                  var variance = double.parse(variancecontroller.text);
                  var n = int.parse(ncontroller.text);
                  setState(() {
                    average = double.parse(meancontroller.text);
                    varnce = double.parse(variancecontroller.text);
                  });

                  //square-root choice

                  var k = logBase(n, 2).round();
                  print(k);

                  //GENERATORS
                  double findSumCi() {
                    var sumCi = 0.0;
                    for (int i = 0; i < 12; i++) {
                      sumCi += (rnd.nextDouble() * (1 - 0) + 0);
                    }
                    return sumCi - 6;
                  }

                  var normalRV = List.generate(
                      n, (index) => mean + sqrt(variance) * findSumCi());
                  print('NRV : $normalRV');

                  var minNRV = normalRV.reduce(min).round();
                  var maxNRV = normalRV.reduce(max).round();
                  print('max $maxNRV, min $minNRV');

                  //INTERVAL LENGTH
                  var intervalrange = (maxNRV - minNRV) / k;
                  var intervalMincurr = minNRV.toDouble();
                  var intervalMaxcurr = minNRV + intervalrange;

                  for (int i = 0; i < k; i++) {
                    IntervalClass intervaltemp = IntervalClass(
                        min: intervalMincurr, max: intervalMaxcurr);
                    for (int j = 0; j < n; j++) {
                      if (normalRV[j] > intervalMincurr &&
                          normalRV[j] < intervalMaxcurr) {
                        intervaltemp.countSample += 1;
                      }
                    }
                    intervaltemp.freq = intervaltemp.countSample / n;
                    intervalList.add(intervaltemp);
                    intervalMincurr += intervalrange;
                    intervalMaxcurr += intervalrange;
                  }

                  print('interval : $intervalList');
                  for (int i = 0; i < intervalList.length; i++) {
                    print('freq = ${intervalList[i].freq}');
                  }

                  //DRAW BAR MODEL
                  for (int a = 0; a < k; a++) {
                    //ADD TO BAR CHART
                    data.add(BarModel(
                        n: intervalList[a].toString(),
                        freq: double.parse(
                            intervalList[a].freq.toStringAsFixed(2)),
                        color: charts.ColorUtil.fromDartColor(Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0))));
                  }

                  //AVERAGE MEAN
                  for (int i = 0; i < k; i++) {
                    setState(() {
                      empAvg += i * intervalList[i].freq;
                    });
                  }
                  setState(() {
                    errorAvg = (empAvg - average).abs() / (average).abs();
                  });

                  //VARIANCE
                  for (int i = 0; i < k; i++) {
                    empVar += (i + 1) * (i + 1) * intervalList[i].freq;
                  }
                  setState(() {
                    empVar -= empAvg * empAvg;
                    errorVar = (empVar - variance).abs() / (variance).abs();
                  });

                  //COUNT CHI SQUARED
                  for (int i = 0; i < k; i++) {
                    var pith = intervalList[i].max -
                        intervalList[i].min * intervalList[i].freq;
                    var denominator = n * pith;
                    var numerator = intervalList[i].countSample *
                        intervalList[i].countSample;
                    if (denominator != 0) {
                      chisquared += numerator / denominator;
                    }
                  }

                  setState(() {
                    chisquared -= n;
                  });

                  if (chisquared < 0.0) {
                    chisquared = 0.0;
                    for (int i = 0; i < k; i++) {
                      var pith = intervalList[i].max -
                          intervalList[i].min * intervalList[i].freq;
                      var denominator = n * pith;
                      var numerator =
                          (intervalList[i].countSample - denominator) *
                              (intervalList[i].countSample - denominator);
                      if (denominator != 0) {
                        setState(() {
                          chisquared += numerator / denominator;
                        });
                      }
                    }
                  }

                  print(chisquared);
                },
                child: Container(
                  height: 60.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueGrey),
                  child: const Center(
                    child: Text(
                      'START',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: OrdinalComboBarLineChart.withSampleData(seriesStack),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                'Interval = ${intervalList.toString()} ',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                'Average = ${average.toStringAsFixed(2)} (error= ${errorAvg.toStringAsFixed(2)}%)',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                'Variance = ${varnce.toStringAsFixed(2)} (error= ${errorVar.toStringAsFixed(2)}%)',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                'Chi-squared = ${chisquared.toStringAsFixed(2)} > 9.488 is ${chisquared > 9.488 ? 'True' : 'False'}',
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
