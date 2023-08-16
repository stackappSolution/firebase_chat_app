

import 'package:shared_preferences/shared_preferences.dart';

const String getLanguage = 'language';

Future<void> setStringValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getStringValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
