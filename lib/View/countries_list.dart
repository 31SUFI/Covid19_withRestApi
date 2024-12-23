import 'package:covid_tracker/Services/Utlities/stats_services.dart';
import 'package:covid_tracker/View/country_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CountriesList extends StatefulWidget {
  CountriesList({Key? key}) : super(key: key);

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  TextEditingController searchController = TextEditingController();
  List<dynamic> countries = []; // Full list of countries
  List<dynamic> filteredCountries = []; // Filtered list based on search input

  @override
  Widget build(BuildContext context) {
    WorldStatsServices worldStatsServices = WorldStatsServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  hintText: 'Search with country name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    filteredCountries = countries
                        .where((country) => country['country']
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: worldStatsServices.getCountries(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitRipple(
                        color: Colors.white,
                        size: 50.0,
                        controller: _controller,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    // Populate full list of countries when data is loaded
                    countries = snapshot.data!;
                    filteredCountries = filteredCountries.isEmpty
                        ? countries
                        : filteredCountries;

                    return ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        final countryName =
                            country?['country'] ?? 'Unknown Country';
                        final cases = country['cases'] ?? 0;

                        return ListTile(
                          leading: Image(
                            height: 50,
                            width: 50,
                            image: NetworkImage(
                                country['countryInfo']['flag'] ?? ''),
                          ),
                          title: Text(countryName),
                          subtitle: Text('Cases: $cases'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CountryDetails(
                                          image: country['countryInfo']['flag'],
                                          countryName: country['country'],
                                          totalCases: country['cases'],
                                          todayCases: country['todayCases'],
                                          totalDeaths: country['deaths'],
                                          todayDeaths: country['todayDeaths'],
                                          totalRecovered: country['recovered'],
                                          todayRecovered:
                                              country['todayRecovered'],
                                          active: country['active'],
                                          critical: country['critical'],
                                          test: country['tests'],
                                          population: country['population'],
                                          continent: country['continent'],
                                        )));
                          },
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
