import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wareflow/constants/constants.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Analytics", style: kTitleTextStyle),
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
        //   IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        // ],
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 2,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  final labels = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                  ];
                                  return Text(
                                    labels[value.toInt()],
                                    style: TextStyle(color: Colors.black),
                                  );
                                },
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 10000,
                                getTitlesWidget:
                                    (value, _) => Text(
                                      '${(value / 1000).toStringAsFixed(0)}k',
                                    ),
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              spots: [
                                FlSpot(0, 12000),
                                FlSpot(1, 18000),
                                FlSpot(2, 25000),
                                FlSpot(3, 23000),
                                FlSpot(4, 29000),
                              ],
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.3),
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.blueAccent, Colors.greenAccent],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 2,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  final dates = [
                                    'Jun 1',
                                    'Jun 3',
                                    'Jun 5',
                                    'Jun 7',
                                  ];
                                  return Text(
                                    dates[value.toInt()],
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                                interval: 1,
                              ),
                            ),
                          ),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(toY: 15, color: Colors.teal),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(toY: 30, color: Colors.teal),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(toY: 10, color: Colors.teal),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(toY: 25, color: Colors.teal),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 2,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: 40,
                              color: Colors.green,
                              title: 'Ready',
                              titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: 35,
                              color: Colors.orange,
                              title: 'Distributed',
                              titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: 25,
                              color: Colors.red,
                              title: 'Delayed',
                              titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 2,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          backgroundColor: Colors.transparent,
                          minX: 0,
                          maxX: 2,
                          minY: 0,
                          maxY: 60000,
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text(
                                        'MAR',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      );
                                    case 1:
                                      return const Text(
                                        'JUN',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      );
                                    case 2:
                                      return const Text(
                                        'SEP',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      );
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value == 10000 ||
                                      value == 30000 ||
                                      value == 50000) {
                                    return Text(
                                      '${(value / 1000).toStringAsFixed(0)}k',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                interval: 10000,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  return LineTooltipItem(
                                    '${spot.y.toInt()}',
                                    TextStyle(color: Colors.black),
                                  );
                                }).toList();
                              },
                            ),
                            handleBuiltInTouches: true,
                            touchCallback:
                                (
                                  FlTouchEvent event,
                                  LineTouchResponse? response,
                                ) {},
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.cyan,
                              gradient: LinearGradient(
                                colors: [Colors.cyanAccent, Colors.tealAccent],
                              ),
                              barWidth: 4,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal.withOpacity(0.3),
                                    Colors.teal.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              dotData: FlDotData(show: false),
                              spots: [
                                FlSpot(0, 30000),
                                FlSpot(1, 55000),
                                FlSpot(2, 35000),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 2,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(toY: 10),
                                BarChartRodData(
                                  toY: 5,
                                  color: Colors.deepOrangeAccent,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(toY: 5),
                                BarChartRodData(
                                  toY: 2,
                                  color: Colors.deepOrangeAccent,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(toY: 3),
                                BarChartRodData(
                                  toY: 5,
                                  color: Colors.deepOrangeAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                        duration: Duration(milliseconds: 150), // Optional
                        curve: Curves.linear, // Optional
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
