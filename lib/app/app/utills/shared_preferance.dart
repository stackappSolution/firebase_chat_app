import 'package:shared_preferences/shared_preferences.dart';

Future<String?>? getPrefStringValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setPrefStringValue(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
  const String getLanguage = 'language';
  const String language = 'selectedLanguage';
  const String emoji = 'emoji';
  const String chatColor = 'chatColor';
  const String wallPaperColor = 'wallpaperColor';

  setStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
