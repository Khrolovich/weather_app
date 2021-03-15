import 'package:connectivity/connectivity.dart';

Connectivity connectivity = Connectivity();

Future<bool> isConnection() async {
  bool b = await connectivity.checkConnectivity().then((value) {
    if (value == ConnectivityResult.mobile ||
        value == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  });
  return b;
}
