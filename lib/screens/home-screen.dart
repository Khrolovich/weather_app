import 'package:flutter/material.dart';
import 'package:weather_app/services/weather-data.dart';
import 'package:weather_app/services/place-service.dart';
//import 'package:weather_app/widgets/cityes-list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String textFieldValue = 'textField';
  String cityName;
  String temp = 'temp';
  WeatherData weatherData = WeatherData();

  List<String> suggestions;

  List<String> citiesList = [
    'Current Location',
  ];
  Map<String, String> citiesTemp = {
    'Current Location': '-',
  };

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    getLocalTemp();
  }

  void getLocalTemp() async {
    temp = await weatherData.getLocTemp();
    setState(() {
      citiesTemp['Current Location'] = temp;
    });
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
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () async {
              bool isTrue = false;
              print(citiesList);
              print(citiesTemp);
              temp = await weatherData.getLocTemp();
              citiesList.forEach((element) {
                if (element == 'Current Location') {
                  isTrue = true;
                }
              });
              if (!isTrue) {
                citiesList.add('Current Location');
              }
              setState(() {
                citiesTemp['Current Location'] = temp;
              });
            },
          )
        ],
      ),
      body: Container(
        child: DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 1.0,
          expand: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              child: ListView.builder(
                controller: scrollController,
                itemCount: citiesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        citiesTemp.remove(citiesList[index]);
                        citiesList.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    key: Key(citiesList[index]),
                    child: InkWell(
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(citiesList[index]),
                          ],
                        ),
                        trailing: Text('${citiesTemp[citiesList[index]]} °'),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 700,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Text('Enter City Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                    TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 30)),
                      autofocus: true,
                      onChanged: (String value) async {
                        textFieldValue = value;
                        PlaceApiProvider apiProvider = PlaceApiProvider();
                        suggestions = await apiProvider.fetchSuggestions(value);
                        print(suggestions);
                      },
                      controller: _controller,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          print(citiesList);
                          print(citiesTemp);
                          cityName = textFieldValue[0].toUpperCase() +
                              textFieldValue.substring(1);
                          print(cityName);
                          for (var x in citiesList) {
                            if (x == cityName) {
                              Navigator.pop(context);
                              return;
                            }
                          }
                          temp = await weatherData.getCityTemp(cityName);
                          if (temp == 'error') {
                            Navigator.pop(context);
                            return;
                          }
                          citiesList.add(cityName);
                          citiesTemp[cityName] = temp;
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('Search')),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
