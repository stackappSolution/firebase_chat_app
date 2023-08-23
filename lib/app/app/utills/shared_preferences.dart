

import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/app_utills.dart';

const String getLanguage = 'language';
const String getFontSize = 'fontSize';
const String fontSizes = 'selectedFontSize';
const String language = 'selectedLanguage';
const String emoji = 'emoji';

 setStringValue(String key, String value) async {
   logs('setStringValue');
  SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString(key, value);
}

Future<String?> getStringValue(String key) async {
   logs('getStringValue');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);

}


