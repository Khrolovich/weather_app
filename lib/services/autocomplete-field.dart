import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/connection-check.dart';
import 'package:weather_app/services/place-service.dart';
import 'package:weather_app/widgets/cities-list-model.dart';

class ACompleteForm extends StatefulWidget {
  @override
  _ACompleteFormState createState() => _ACompleteFormState();
}

class _ACompleteFormState extends State<ACompleteForm> {
  @override
  Widget build(BuildContext context) {
    //String _dropdownValue;
    String _autocompleteSelection;
    PlaceApiProvider apiProvider = PlaceApiProvider();
    final TextEditingController _textEditingController =
        TextEditingController();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            TypeAheadFormField(
              hideOnLoading: true,
              noItemsFoundBuilder: (BuildContext context) {
                return;
              },
              errorBuilder: (BuildContext context, error) {
                return;
              },
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                controller: _textEditingController,
                onChanged: (String value) {
                  context.read<CitiesListModel>().setTextInput(value);
                },
                decoration: InputDecoration(
                  labelText: 'City',
                  suffix: TextButton(
                    onPressed: () async {
                      bool b = await isConnection();
                      if (b) {
                        String response =
                            await context.read<CitiesListModel>().addPlace();
                        if (response == 'exist') {
                          showDialog<SimpleDialog>(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 20),
                                      child: Text('This place already exist')),
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
                        } else if (response == 'error') {
                          //context.read<CitiesListModel>().notFoundToFalse();
                          showDialog<SimpleDialog>(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text('Sorry'),
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(24, 0, 24, 20),
                                      child: Text(
                                          'This place doesn\'t exist or lost connection.')),
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
                        } else if (response == 'ok') {
                          Navigator.pop(context);
                        } else if (response == 'empty') {
                          return;
                        } else {
                          showDialog<SimpleDialog>(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text('Sorry'),
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 20),
                                      child: Text('Something wrong...')),
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
                    child: Text('Add'),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) {
                return apiProvider
                    .fetchSuggestions(pattern); //.getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                _textEditingController.text = suggestion;
                context.read<CitiesListModel>().setTextInput(suggestion);
              },
              onSaved: (value) => _autocompleteSelection = value,
            ),
          ],
        ),
      ),
    );
  }
}
