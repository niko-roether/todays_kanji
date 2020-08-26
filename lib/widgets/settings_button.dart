import 'package:flutter/material.dart';
import 'package:todays_kanji/screens/settings.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings, color: Colors.white),
      onPressed: () => Navigator.pushNamed(context, SettingsScreen.ROUTENAME),
      tooltip: "Settings",
    );
  }
}
