import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/util/general.dart';

class KanjiUpdater extends InheritedWidget {
  static const _DAY_LENGTH_MILLISEC = 86400000;
  static const _CHECK_INTERVAL = Duration(seconds: 1);
  final AppState _appState;
  final _kanjiSource = KanjiSource();
  final PreferencesModel _prefs;
  Timer updateThread;

  KanjiUpdater({@required AppState appState, Widget child})
      : _appState = appState,
        _prefs = appState.preferences,
        super(child: child) {
    updateThread = Timer.periodic(_CHECK_INTERVAL, (timer) => _update());
  }

  Future<void> reroll() async {
    if (_appState.loadingKanji) return;
    _appState.loadingKanji = true;
    _prefs.kanjiTimestamp = todayTimestamp();
    _prefs.kanjiSymbol = await _kanjiSource.randomKanjiSymbol(
      maxJlpt: _prefs.maxJLPT,
    );
    _appState.loadingKanji = false;
  }

  void _update() {
    int now = DateTime.now().millisecondsSinceEpoch;
    int diff = now - _prefs.kanjiTimestamp;
    if (_prefs.kanjiSymbol == null || diff > _DAY_LENGTH_MILLISEC) reroll();
  }

  static KanjiUpdater of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KanjiUpdater>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
