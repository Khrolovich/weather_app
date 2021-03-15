import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/autocomplete-field.dart';
import 'package:weather_app/widgets/cities-list-model.dart';

class CitySelectionScreen extends StatelessWidget {
  final String title;
  const CitySelectionScreen(this.title);

  @override
  Widget build(BuildContext context) {
    context.read<CitiesListModel>().setTextInput('');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Column(
              children: [
                ACompleteForm(),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Container(
                width: 170,
                child: Image(
                  image: AssetImage(
                      'assets/images/powered_by_google_on_white@3x.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
