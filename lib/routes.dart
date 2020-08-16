import 'package:flutter/material.dart';
import 'package:todays_kanji/screens/settings.dart';
import 'package:todays_kanji/screens/home.dart';

Map<String, WidgetBuilder> loadRoutes() {
  return {
    "/": (BuildContext context) => HomeScreen(),
    "/settings": (BuildContext context) => SettingsScreen()
  };
}
