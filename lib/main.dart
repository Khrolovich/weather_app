import 'package:flutter/material.dart';
import 'package:weather_app/screens/home-screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Weather App'),
      },
      initialRoute: '/',
    );
  }
}

// TODO: добавить лого powered by Google
// TODO:
