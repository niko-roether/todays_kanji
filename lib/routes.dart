import 'package:flutter/material.dart';
import 'package:todays_kanji/screens/kanji.dart';
import 'package:todays_kanji/screens/settings.dart';
import 'package:todays_kanji/screens/home.dart';
import 'package:todays_kanji/screens/word.dart';

const INITIAL_ROUTE = HomeScreen.ROUTENAME;

Map<String, WidgetBuilder> loadRoutes() {
  return {
    HomeScreen.ROUTENAME: (context) => HomeScreen(),
    SettingsScreen.ROUTENAME: (context) => SettingsScreen(),
    KanjiScreen.ROUTENAME: (context) => KanjiScreen(),
    WordScreen.ROUTENAME: (context) => WordScreen()
  };
}
