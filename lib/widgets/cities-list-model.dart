import 'package:flutter/widgets.dart';
import 'package:weather_app/services/place-service.dart';
import 'package:weather_app/services/weather-data.dart';

class CitiesListModel extends ChangeNotifier {
  final PlaceApiProvider _apiProvider = PlaceApiProvider();
  String currentLocationName = 'Current location';
  String _currentTemp = '-';
  List<String> _citiesList = [
    'Current location',
  ];
  Map<String, String> _citiesTemp = {
    'Current location': '-',
  };
  Map<String, String> _citiesIDs = {};
  Map<String, bool> _cityTempByIDExisting = {};
  bool _currentLocationExisting = true;
  bool get getCurrentLocationExisting => _currentLocationExisting;

  WeatherData _weatherData = WeatherData();
  String _textInput = '';
  List<String> get getItems => _citiesList;
  Map<String, String> get tempMap => _citiesTemp;
  String get getLocalTemp => _currentTemp;
  // bool _ifLocationPermission = false;
  // bool get locationPermission => _ifLocationPermission;
  //
  // void setLocationPermission(String p) {}

  void addCurrentLocation() {
    bool currentLocationExist = false;
    _citiesList.forEach((element) {
      if (element == currentLocationName) {
        currentLocationExist = true;
        return;
      }
    });
    if (currentLocationExist) {
      return;
    }
    _citiesList.insert(0, currentLocationName);
    _citiesTemp[currentLocationName] = '-';
    _currentLocationExisting = true;
    updateWeatherData();
    notifyListeners();
  }

  void setTextInput(String value) {
    _textInput = value;
  }

  Future<String> getWeatherDataByLocation() async {
    String temp = await _weatherData.getLocTemp();
    return temp;
  }

  Future<String> getWeatherDataByCityName(String name) async {
    String temp = await _weatherData.getCityTemp(name);
    return temp;
  }

  Future<String> getWeatherDataByID(String _id) async {
    String temp = await _weatherData.getIDTemp(_id);
    return temp;
  }

  Future updateWeatherData() async {
    _citiesTemp.forEach((key, value) {
      _citiesTemp[key] = '-';
      notifyListeners();
    });
    _citiesTemp.forEach((key, value) async {
      if (key == 'Current location') {
        await getWeatherDataByLocation().then(
          (v) {
            if (v == 'error') {
              _citiesTemp[key] = '-';
            } else {
              _citiesTemp[key] = v;
            }
            notifyListeners();
          },
        );
      } else {
        if (_cityTempByIDExisting[key]) {
          await getWeatherDataByID(_citiesIDs[key]).then((value) async {
            if (value == 'error') {
              await getWeatherDataByCityName(key).then((value) {
                if (value == 'error') {
                  _citiesTemp[key] = '-';
                } else {
                  _citiesTemp[key] = value;
                }
                notifyListeners();
              });
            } else {
              _citiesTemp[key] = value;
            }
            notifyListeners();
          });
        } else {
          await getWeatherDataByCityName(key).then((value) {
            if (value == 'error') {
              _citiesTemp[key] = '-';
            } else {
              _citiesTemp[key] = value;
            }
            notifyListeners();
          });
        }
      }
    });
  }

  bool _isPlaceExist = false;

  bool _notFoundAlert = false;
  bool get notFoundAlert => _notFoundAlert;
  void notFoundToFalse() {
    _notFoundAlert = false;
  }

  Future<String> getCityID() async {
    String _id = await _apiProvider.getPlaceID(_textInput);
    return _id;
  }

  Future<String> setCityID() async {
    String setIDResponse = await getCityID().then((id) {
      print('ID set to $id');
      if (id == 'error') {
        return 'error';
      }
      _citiesIDs.forEach((key, value) {
        if (value == id) {
          _isPlaceExist = true;
          return;
        }
      });

      if (_isPlaceExist) {
        _isPlaceExist = false;
        return 'exist';
      }
      _citiesList.add(_textInput);
      _citiesIDs[_textInput] = id;
      print('Text input is $_textInput');
      print('City list set to: $_citiesList');
      print('City IDs set to: $_citiesIDs');
      print('return id: $id');
      return id;
    });
    print('ID response: $setIDResponse');
    return setIDResponse;
  }

  Future<String> addPlace() async {
    print('Text input: $_textInput');
    if (_textInput == '') {
      return 'empty';
    }
    _citiesList.forEach((element) {
      if (element == _textInput) {
        _isPlaceExist = true;
        return;
      }
    });

    if (_isPlaceExist) {
      _isPlaceExist = false;
      return 'exist';
    }

    String response = 'ok';
    await setCityID().then((value) async {
      if (value == 'exist') {
        response = 'exist';
        return;
      }
      if (value != 'error') {
        await _weatherData
            .getIDTemp(_citiesIDs[_textInput])
            .then((value) async {
          if (value == 'error') {
            _cityTempByIDExisting[_textInput] = false;
            await _weatherData.getCityTemp(_textInput).then((v) {
              if (v == 'error') {
                removeAt(_citiesList.indexOf(_textInput));
                response = 'error';
              } else {
                _citiesTemp[_textInput] = v;
                notifyListeners();
                print(_citiesList);
                print(_citiesTemp);
                print(_citiesIDs);
              }
            });
          } else {
            if (value == 'error') {
              removeAt(_citiesList.indexOf(_textInput));
              response = 'error';
            } else {
              _cityTempByIDExisting[_textInput] = true;
              _citiesTemp[_textInput] = value;
              notifyListeners();
              print(_citiesList);
              print(_citiesTemp);
              print(_citiesIDs);
            }
          }
        });
      }
      //return 'ok';
    });
    print('response $response');
    return response;
  }

  void removeAt(int index) {
    if (_citiesList[index] == currentLocationName) {
      _currentLocationExisting = false;
    }
    _citiesTemp.remove(_citiesList[index]);
    _citiesIDs.remove(_citiesList[index]);
    _cityTempByIDExisting.remove(_citiesList[index]);
    _citiesList.removeAt(index);
    notifyListeners();
  }
}
