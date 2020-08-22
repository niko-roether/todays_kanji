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

  int get rerollInterval =>
      _preferences.getInt("rerollInterval") ?? (rerollInterval = 86400000);
  set rerollInterval(int value) {
    _preferences.setInt("rerollInterval", value);
  }

  bool get readingsAsRomaji =>
      _preferences.getBool("readingsAsRomaji") ?? (readingsAsRomaji = false);
  set readingsAsRomaji(bool value) {
    _preferences.setBool("readingsAsRomaji", value);
    notifyListeners();
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
