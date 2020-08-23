import 'package:flutter/material.dart';
import 'package:todays_kanji/model/preferences_model.dart';

class AppState extends ChangeNotifier {
  final PreferencesModel preferences;
  bool _loadingKanji = false;

  AppState({this.preferences}) {
    preferences.addListener(() {
      loadingKanji = false;
      notifyListeners();
    });
  }

  bool get loadingKanji => _loadingKanji;
  set loadingKanji(bool value) {
    _loadingKanji = value;
    notifyListeners();
  }
}
