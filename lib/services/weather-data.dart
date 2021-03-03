import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'location-getter.dart';

class WeatherData {
  // final double longitude, latitude;
  // final String cityName;
  // WeatherData({this.longitude, this.latitude, this.cityName});

  final String apiKey = '4b2e34fdf66e063ac4adddaf349407a8';
  String url;

  Future<dynamic> getWeatherData(
      {double longitude, double latitude, String cityName}) async {
    try {
      if (latitude != null && longitude != null && cityName == null) {
        url =
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
      } else if (latitude == null && longitude == null && cityName != null) {
        url =
            'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
      }
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'Oops..';
    }
  }

  Future<String> getCityTemp(String city) async {
    var jsonData = await getWeatherData(cityName: city);
    var temp;
    try {
      temp = jsonData['main']['temp'];
    } catch (e) {
      print(e);
    }
    print('Tempreture is $temp.');

    if (temp == null) {
      return 'error';
    }
    return temp.toInt().toString();
  }

  Future<String> getLocTemp() async {
    double latitude, longitude;

    CurrentLocation location = CurrentLocation();
    await location.getCurrentLocation();
    try {
      longitude = location.longitude;
      latitude = location.latitude;
    } catch (e) {
      print(e);
    }
    print('Longitude: $longitude, latitude: $latitude');

    var jsonData =
        await getWeatherData(latitude: latitude, longitude: longitude);
    var temp;
    try {
      temp = jsonData['main']['temp'];
    } catch (e) {
      print(e);
    }
    print('Tempreture is $temp.');

    if (temp == null) {
      return 'error';
    }
    return temp.toInt().toString();
  }
}
