import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/app_utills.dart';

Future<String?>? getPrefStringValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  logs('prefs.getString(key) :${prefs.getString(key)}');

  return prefs.getString(key);
}

setPrefStringValue(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
