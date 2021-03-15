import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_app/keys.dart';

class PlaceApiProvider {
  final client = Client();

  final apiKey = kPlacesAPIKey;

  Future<String> getPlaceID(String input) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&language=en&key=$apiKey';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        String placeID = result['candidates'][0]['place_id'];
        print(placeID);
        return placeID;
      } else {
        // if (result['status'] == 'ZERO_RESULTS') {
        //   return 'error';
        // }
        return 'error';
      }
      //throw Exception(result['error_message']);
    } else {
      return 'error';
      //throw Exception('Failed to fetch suggestion');
    }
  }

  Future<List<String>> fetchSuggestions(String input) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&lang=en&types=(regions)&key=$apiKey';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        List citiesList = result['predictions']
            .map<String>((p) => p['description'].toString())
            .toList();
        print(citiesList);
        return citiesList;
      } else {
        //if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      //throw Exception(result['error_message']);
    } else {
      return [];
      //throw Exception('Failed to fetch suggestion');
    }
  }
}
