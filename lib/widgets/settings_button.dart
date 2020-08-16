import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings, color: Colors.white),
      onPressed: () => Navigator.pushNamed(context, "/settings"),
      tooltip: "Settings",
    );
  }
}
