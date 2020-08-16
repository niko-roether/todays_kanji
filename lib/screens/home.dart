import "package:flutter/material.dart";
import 'package:todays_kanji/kanji_icons.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/widgets/tabs/todayskanji.dart';
import 'package:todays_kanji/widgets/tabs/words.dart';
import 'package:todays_kanji/widgets/settings_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tabs = [
      Tab(icon: Icon(KanjiIcons.character), text: "Character"),
      Tab(icon: Icon(KanjiIcons.words), text: "Browse Words")
    ];

    return ScrollConfiguration(
      behavior: RubberBandScroll(),
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            title: Text("Today's Kanji"),
            centerTitle: true,
            actions: [SettingsButton()],
            bottom: TabBar(
              tabs: tabs,
            ),
          ),
          body: SizedBox.expand(
            child: TabBarView(
              children: [TodaysKanjiTab(), WordsTab()],
            ),
          ),
        ),
      ),
    );
  }
}
