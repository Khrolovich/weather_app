import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/connection-check.dart';
import 'package:weather_app/widgets/cities-list-model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<CitiesListModel>().updateWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          LocationButton(
              context.watch<CitiesListModel>().getCurrentLocationExisting),
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () async {
              bool b = await isConnection();

              if (b == true) {
                context.read<CitiesListModel>().updateWeatherData();
              } else {
                showDialog<SimpleDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('Network issue'),
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                          child: Text('Check internet connection'),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Text('Ok'),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 100),
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          expand: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              child: ListView.builder(
                controller: scrollController,
                itemCount: context.watch<CitiesListModel>().getItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      context.read<CitiesListModel>().removeAt(index);
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
                    key: Key(context.watch<CitiesListModel>().getItems[index]),
                    child: InkWell(
                      child: ListTile(
                        title: Wrap(
                          children: [
                            Text(context
                                .watch<CitiesListModel>()
                                .getItems[index]),
                          ],
                        ),
                        trailing: Text(
                            '${context.watch<CitiesListModel>().tempMap[context.watch<CitiesListModel>().getItems[index]]} °'),
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
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/city-selection-screen');
          context.read<CitiesListModel>().setTextInput('');
        },
      ),
    );
  }
}

class LocationButton extends StatefulWidget {
  final bool b;
  LocationButton(this.b);
  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.b) {
      return Container(
        width: 48,
        height: 56,
      );
    } else {
      return Container(
        width: 48,
        height: 56,
        child: IconButton(
          icon: Icon(Icons.my_location),
          onPressed: () async {
            bool serviceEnabled;
            LocationPermission permission;

            serviceEnabled = await Geolocator.isLocationServiceEnabled();
            permission = await Geolocator.checkPermission();
            if (!serviceEnabled) {
              showDialog<SimpleDialog>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Sorry'),
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                          child: Text('Location services are disabled')),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text('Ok'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (permission == LocationPermission.deniedForever) {
              showDialog<SimpleDialog>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Sorry'),
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                          child: Text(
                              'You need enable location permission in setting for the app.')),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text('Ok'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              context.read<CitiesListModel>().addCurrentLocation();
            }
          },
        ),
      );
    }
  }
}
