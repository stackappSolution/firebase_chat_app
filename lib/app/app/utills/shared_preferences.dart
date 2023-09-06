import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal/app/app/utills/app_utills.dart';

const String getLanguage = 'language';
const String getFontSize = 'fontSize';
const String fontSizes = 'setFontSize';
const String language = 'selectedLanguage';
const String emoji = 'emoji';
const String chatColor = 'chatColor';
const String wallpaper = 'wallpaper';
const String wallPaperColor = 'wallpaperColor';

 setStringValue(String key, String value) async {
   logs('setStringValue');
  SharedPreferences prefs = await SharedPreferences.getInstance();

   prefs.setString(key, value);
}

Future<String?> getStringValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setIntValue(String key, int value) async {
  logs('setIntValue');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

Future<int?> getIntValue(String key) async {
  logs('getIntValue');
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}
