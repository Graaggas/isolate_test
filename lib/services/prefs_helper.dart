import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static String sharedPrefsKey = 'USE_ISOLATES_TOGGLE_VALUE';

  static Future<bool> saveData(bool value) async {
    final sharedPrefs = await SharedPreferences.getInstance();

    return await sharedPrefs.setBool(sharedPrefsKey, value);
  }

  static Future<bool> getData() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    return sharedPrefs.getBool(sharedPrefsKey) ?? false;
  }
}
