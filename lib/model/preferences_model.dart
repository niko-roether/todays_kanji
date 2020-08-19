import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

class PreferencesModel extends ChangeNotifier {
  final SharedPreferences _preferences;

  PreferencesModel(this._preferences);

  String get kanjiSymbol => _preferences.get("kanjiSymbol");
  set kanjiSymbol(String symbol) {
    _preferences.setString("kanjiSymbol", symbol);
    notifyListeners();
  }

  int get kanjiTimestamp => _preferences.get("kanjiTimestamp");
  set kanjiTimestamp(int timestamp) {
    _preferences.setInt("kanjiTimestamp", timestamp);
  }

  int get maxJLPT => _preferences.get("maxJLPT") ?? (maxJLPT = 0);
  set maxJLPT(int value) {
    _preferences.setInt("maxJLPT", value);
  }

  int get rerollInterval =>
      _preferences.get("rerollInterval") ?? (rerollInterval = 86400000);
  set rerollInterval(int value) {
    _preferences.setInt("rerollInterval", value);
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
