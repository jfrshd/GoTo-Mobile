import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static setStringList(String code, List<Object> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(code, value);
  }

  static Future<List<String>> getStringList(
      String code, int defaultSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(code) ?? new List.filled(defaultSize, "");
  }

  static setString(String code, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(code, value);
  }

  static Future<String> getString(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(code) ?? "";
  }

  static setInt(String code, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(code, value);
  }

  static Future<int> getInt(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(code) ?? -1;
  }

  static setBool(String code, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(code, value);
  }

  static Future<bool> getBool(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(code) ?? true;
  }
}
