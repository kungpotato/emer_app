import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  ThemePreferences._internal();

  static final ThemePreferences _singleton = ThemePreferences._internal();

  static ThemePreferences get instance {
    return _singleton;
  }

  late SharedPreferences prefs;

  final String key = 'theme';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool get isLight => prefs.getBool(key) ?? false;

  void setIsLight(bool value) {
    prefs.setBool(key, value);
  }
}
