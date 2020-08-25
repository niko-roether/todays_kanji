import 'package:flutter/material.dart';

// TODO unacceptable
final _darkColorScheme = ColorScheme(
  background: Color.fromRGBO(11, 5, 0, 1),
  brightness: Brightness.dark,
  error: Color.fromRGBO(219, 22, 47, 1),
  onBackground: Color.fromRGBO(220, 220, 220, 1),
  onError: Color.fromRGBO(220, 220, 220, 1),
  onPrimary: Color.fromRGBO(220, 220, 220, 1),
  onSecondary: Color.fromRGBO(255, 255, 255, 1),
  onSurface: Color.fromRGBO(143, 201, 58, 1),
  primary: Color.fromRGBO(40, 40, 40, 1),
  primaryVariant: Color.fromRGBO(20, 20, 20, 1),
  secondary: Color.fromRGBO(143, 201, 58, 1),
  secondaryVariant: Color.fromRGBO(110, 155, 43, 1),
  surface: Color.fromRGBO(40, 40, 40, 1),
);

final _textTheme = TextTheme(
  headline1: TextStyle(fontSize: 150),
  headline2: TextStyle(fontSize: 60),
);

final darkTheme = ThemeData.from(
  colorScheme: _darkColorScheme,
  textTheme: _textTheme,
);
