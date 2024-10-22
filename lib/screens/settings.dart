import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/view/preferences_view.dart';
import 'package:todays_kanji/widgets/screen.dart';

class SettingsScreen extends StatelessWidget {
  static const ROUTENAME = "/settings";

  @override
  Widget build(BuildContext context) {
    return Screen(
      appBar: AppBar(title: Text("Settings"), centerTitle: true),
      child: Consumer<AppState>(
        builder: (context, state, child) => PreferencesView(state.preferences),
      ),
    );
  }
}
