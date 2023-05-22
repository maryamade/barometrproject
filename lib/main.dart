import 'package:flutter/material.dart';
import 'package:flutter_barometer/flutter_barometer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(barometer_app());
}

class barometer_app extends StatefulWidget {
  @override
  State<barometer_app> createState() => _barometer_appState();
}

class _barometer_appState extends State<barometer_app> {
  late StreamSubscription _streamSubscription;
  double _pressure = 0.0;
  double _height = 0.0;
  double home = 0.0;
  double fci = 0.0;
  double home_pressure = 0.0;
  double fci_pressure = 0.0;

  double calculateHeight(double pressure) {
    double pressure0 = 101325; // Air pressure at sea level (Pa)
    double G = 8.314; // Gas constant (J/mol*K)
    double T = 293; // Temperature (K)
    double g = 9.81; // Acceleration due to gravity (m/s^2)
    double M = 0.0289644; // Molar mass of air (kg/mol)
    double h = (G * T / g * M) * log(pressure0 / pressure);
    return h;
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription =
        flutterBarometerEvents.listen((FlutterBarometerEvent event) {
      setState(() {
        _pressure = event.pressure;
        _height = calculateHeight(_pressure);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Barometer Aplication'),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 0),
                        FlSpot(_pressure, _height),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Home',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '$home_pressure hpa  ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${home.round()} m',
                        style: TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            home = _height;
                            home_pressure = _pressure;
                          });
                        },
                        child: Text(
                          'Home Hight',
                          style: TextStyle(fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.black,
                          minimumSize: Size(140, 40),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            home = 0;
                            home_pressure = 0;
                          });
                        },
                        child: Text(
                          'Reset Home',
                          style: TextStyle(fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.black,
                          minimumSize: Size(140, 40),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 450,
                  child: VerticalDivider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
                Container(
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'FCI',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '$fci_pressure hpa  ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${fci.round()} m',
                        style: TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            fci = _height;
                            fci_pressure = _pressure;
                          });
                        },
                        child: Text(
                          'FCI Hight',
                          style: TextStyle(fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.black,
                          minimumSize: Size(140, 40),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            fci = 0;
                            fci_pressure = 0;
                          });
                        },
                        child: Text(
                          'Reset FCI',
                          style: TextStyle(fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.black,
                          minimumSize: Size(140, 40),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _height = 0;
                  _pressure = 0;
                  fci = _height;
                  fci_pressure = _pressure;
                  home = _height;
                  home_pressure = _pressure;
                });
              },
              child: Text(
                'Reset',
                style: TextStyle(fontSize: 17),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.black,
                minimumSize: Size(140, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
