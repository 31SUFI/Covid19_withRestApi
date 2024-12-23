import 'package:covid_tracker/Model/world_stats_model.dart';
import 'package:covid_tracker/Services/Utlities/stats_services.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:covid_tracker/Widgets/reusable_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({Key? key}) : super(key: key);

  @override
  _WorldStatsState createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  late Future<CovidStats> futureStats;

  @override
  void initState() {
    super.initState();
    futureStats = WorldStatsServices().getWorldStats();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<CovidStats>(
              future: futureStats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                      controller: _controller,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  final total = stats.cases + stats.recovered + stats.deaths;
                  final dataMap = {
                    "Cases": (stats.cases / total) * 100,
                    "Recovered": (stats.recovered / total) * 100,
                    "Deaths": (stats.deaths / total) * 100,
                  };
                  return Column(
                    children: [
                      PieChart(
                        dataMap: dataMap,
                        chartType: ChartType.ring,
                        chartRadius: MediaQuery.of(context).size.width / 3.5,
                        colorList: [Colors.blue, Colors.green, Colors.red],
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Cards Section using reusable rows
                      buildStatRow('Total Cases', stats.cases.toString()),
                      buildStatRow(
                          'Total Recovered', stats.recovered.toString()),
                      buildStatRow('Total Deaths', stats.deaths.toString()),
                      buildStatRow('Active Cases', stats.active.toString()),
                      buildStatRow('Critical Cases', stats.critical.toString()),
                      buildStatRow('Today Cases', stats.todayCases.toString()),
                      buildStatRow(
                          'Today Deaths', stats.todayDeaths.toString()),
                      buildStatRow(
                          'Today Recovered', stats.todayRecovered.toString()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountriesList(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('Track Countries'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
