import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

class PreferencesModel extends ChangeNotifier {
  static const _DEFAULT_MAX_JLPT = 0;
  static const _DEFAULT_READINGS_AS_ROMAJI = false;
  static const _DEFAULT_REFRESH_TIME = 180;

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

  int get maxJLPT =>
      _preferences.getInt("maxJLPT") ?? (maxJLPT = _DEFAULT_MAX_JLPT);
  set maxJLPT(int value) {
    _preferences.setInt("maxJLPT", value);
  }

  bool get readingsAsRomaji =>
      _preferences.getBool("readingsAsRomaji") ??
      (readingsAsRomaji = _DEFAULT_READINGS_AS_ROMAJI);
  set readingsAsRomaji(bool value) {
    _preferences.setBool("readingsAsRomaji", value);
    notifyListeners();
  }

  TimeOfDay get refreshTime {
    int minutes = _preferences.getInt("refreshTime");
    if (minutes == null) {
      minutes = _DEFAULT_REFRESH_TIME;
      _preferences.setInt("refreshTime", minutes);
    }
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
