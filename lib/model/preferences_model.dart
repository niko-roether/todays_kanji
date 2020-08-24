import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

class PreferencesModel extends ChangeNotifier {
  final SharedPreferences _preferences;

  PreferencesModel(this._preferences);

  String get kanjiSymbol => _preferences.getString("kanjiSymbol");
  set kanjiSymbol(String symbol) {
    _preferences.setString("kanjiSymbol", symbol);
    notifyListeners();
  }

  int get kanjiTimestamp => _preferences.getInt("kanjiTimestamp");
  set kanjiTimestamp(int timestamp) {
    _preferences.setInt("kanjiTimestamp", timestamp);
  }

  int get maxJLPT => _preferences.getInt("maxJLPT") ?? (maxJLPT = 0);
  set maxJLPT(int value) {
    _preferences.setInt("maxJLPT", value);
  }

  bool get readingsAsRomaji =>
      _preferences.getBool("readingsAsRomaji") ?? (readingsAsRomaji = false);
  set readingsAsRomaji(bool value) {
    _preferences.setBool("readingsAsRomaji", value);
    notifyListeners();
  }

  TimeOfDay get refreshTime {
    int minutes = _preferences.getInt("refreshTime");
    return TimeOfDay(hour: (minutes / 60).floor(), minute: minutes % 60);
  }

  set refreshTime(TimeOfDay value) {
    _preferences.setInt("refreshTime", value.hour * 60 + value.minute);
  }

  Map toJson() {
    Map json = {};
    for (String key in this._preferences.getKeys()) {
      json[key] = this._preferences.get(key);
    }
    return json;
  }

  static Future<PreferencesModel> getPreferences() async {
    var instance = PreferencesModel(await SharedPreferences.getInstance());
    return instance;
  }
}
