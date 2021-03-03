import 'dart:convert';
//import 'dart:io';

import 'package:http/http.dart';

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  // @override
  // String toString() {
  //   return 'Suggestion(placeId: $placeId, description: $description)';
  // }
}

class PlaceApiProvider {
  String languege = '';
  final client = Client();
  static final String apiKey = 'AIzaSyAkZtmdf9IKKYbCbOBZ2cKCsOIaUu9md-o';

  Future<List<String>> fetchSuggestions(String input) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';
    final response = await client.get(request);
    List<String> suggestedList;
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        suggestedList = result['predictions']
            .list<String>((s) => s['description'].toString())
            .toList();
        // return result['predictions']
        //     .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
        //     .toList();
        print(suggestedList);
        return suggestedList;
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
