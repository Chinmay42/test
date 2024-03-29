import 'package:shared_preferences/shared_preferences.dart';
class SharedPrefUtils {
static String IMEI='';
static String LATITUDE='';
static String LONGITUDE='';

  static saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, message);
  }

  static readPrefStr(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

}