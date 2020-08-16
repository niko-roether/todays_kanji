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

  // Future<void> rerollKanjiSymbol() async {
  //   loadingKanji = true;
  //   notifyListeners();
  //   preferences.kanjiTimestamp = todayTimestamp();
  //   preferences.kanjiSymbol = await _kanjiSource.randomKanjiSymbol();
  //   loadingKanji = false;
  //   notifyListeners();
  // }

  // Future<void> updateKanjiSymbol() async {
  //   int now = DateTime.now().millisecondsSinceEpoch;
  //   int difference = now - preferences.kanjiTimestamp;
  //   if (preferences.kanjiTimestamp == null || difference > 864000000)
  //     rerollKanjiSymbol();
  // }
}
