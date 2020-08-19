import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/controller/preferences_controller.dart';
import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/routes.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/widgets/inherited/kanji_updater.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PreferencesModel.getPreferences(),
      builder: (context, AsyncSnapshot<PreferencesModel> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        PreferencesModel prefs = snapshot.data;
        var appState = AppState(preferences: prefs);

        return KanjiUpdater(
          appState: appState,
          child: ChangeNotifierProvider(
            create: (context) => appState,
            child: MaterialApp(
              title: "Today's Kanji",
              theme: ThemeData.dark(),
              routes: loadRoutes(),
              initialRoute: INITIAL_ROUTE,
            ),
          ),
        );
      },
    );
  }
}
