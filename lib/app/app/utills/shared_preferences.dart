

import 'package:shared_preferences/shared_preferences.dart';

const String getLanguage = 'language';
const String language = 'selectedLanguage';

 setStringValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString(key, value);
}

Future<String?> getStringValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
