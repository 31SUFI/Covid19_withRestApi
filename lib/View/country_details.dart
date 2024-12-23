import 'package:covid_tracker/Widgets/reusable_row_widget.dart';
import 'package:flutter/material.dart';

class CountryDetails extends StatefulWidget {
  final String countryName;
  final String image;
  final int totalCases;
  final int todayCases;
  final int totalDeaths;
  final int todayDeaths;
  final int totalRecovered;
  final int todayRecovered;
  final int active;
  final int critical;
  final int test;
  final int population;
  final String continent;

  CountryDetails({
    required this.continent,
    required this.population,
    required this.test,
    required this.countryName,
    required this.image,
    required this.totalCases,
    required this.todayCases,
    required this.totalDeaths,
    required this.todayDeaths,
    required this.totalRecovered,
    required this.todayRecovered,
    required this.active,
    required this.critical,
  });

  @override
  _CountryDetailsState createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .06),
                      buildStatRow(
                        'Continent',
                        widget.continent.toString(),
                      ),
                      buildStatRow(
                        'Population',
                        widget.population.toString(),
                      ),
                      buildStatRow(
                        'tests',
                        widget.test.toString(),
                      ),
                      buildStatRow(
                        'Cases',
                        widget.totalCases.toString(),
                      ),
                      buildStatRow(
                        'Today Cases',
                        widget.todayCases.toString(),
                      ),
                      buildStatRow(
                        'Deaths',
                        widget.totalDeaths.toString(),
                      ),
                      buildStatRow(
                        'Today Deaths',
                        widget.todayDeaths.toString(),
                      ),
                      buildStatRow(
                        'Recovered',
                        widget.totalRecovered.toString(),
                      ),
                      buildStatRow(
                        'Today Recovered',
                        widget.todayRecovered.toString(),
                      ),
                      buildStatRow(
                        'Active',
                        widget.active.toString(),
                      ),
                      buildStatRow(
                        'Critical',
                        widget.critical.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.image),
            ),
          ],
        ),
      ),
    );
  }
}
