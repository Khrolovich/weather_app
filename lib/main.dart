import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/screens/city-selection-screen.dart';
import 'package:weather_app/screens/home-screen.dart';
import 'package:weather_app/widgets/cities-list-model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CitiesListModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: kThemePrimaryColor,
      ),
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Weather App'),
        '/city-selection-screen': (context) =>
            CitySelectionScreen('Enter city name'),
      },
      initialRoute: '/',
    );
  }
}

// TODO: добавить лого powered by Google
// TODO:
