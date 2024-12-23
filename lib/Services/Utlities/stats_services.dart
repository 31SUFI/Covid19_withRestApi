import 'dart:convert';

import 'package:covid_tracker/Model/world_stats_model.dart';
import 'package:covid_tracker/Services/Utlities/app_url.dart';
import 'package:http/http.dart ' as http;

class WorldStatsServices {
  Future<CovidStats> getWorldStats() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if (response.statusCode == 200) {
      print("success");
      return CovidStats.fromJson(json.decode(response.body));
    } else {
      print("lore");
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> getCountries() async {
    var countries = [];
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if (response.statusCode == 200) {
      print("success get countries");
      countries = json.decode(response.body);
      return countries;
    } else {
      print("lore get countries");
      throw Exception('Failed to load data');
    }
  }
}
