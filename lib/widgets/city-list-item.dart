import 'package:flutter/material.dart';

class CityListItem extends StatelessWidget {
  final String cityName;
  final double tempreture;
  CityListItem({@required this.cityName, @required this.tempreture});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(cityName),
          Text(tempreture.toString()),
        ],
      ),
    );
  }
}
