import 'package:flutter/material.dart';
import 'package:todays_kanji/controller/preferences_controller.dart';
import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/widgets/preference_category.dart';
import 'package:todays_kanji/widgets/preferences/dropdown_preference.dart';
import 'package:todays_kanji/widgets/preferences/switch_preference.dart';

class PreferencesView extends StatelessWidget {
  final PreferencesModel model;
  final PreferencesController controller;
  PreferencesView(this.model) : controller = PreferencesController(model);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: RubberBandScroll(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 26),
        children: [
          PreferenceCategory(
            heading: "Kanji Roll Options",
            children: [
              DropdownPreference<int>(
                name: "Max JLPT-Level",
                items: [
                  DropdownPreferenceItem(text: "N5", value: 5),
                  DropdownPreferenceItem(text: "N4", value: 4),
                  DropdownPreferenceItem(text: "N3", value: 3),
                  DropdownPreferenceItem(text: "N2", value: 2),
                  DropdownPreferenceItem(text: "N1", value: 1),
                  DropdownPreferenceItem(text: "None", value: 0),
                ],
                initial: model.maxJLPT,
                onChanged: (value) => model.maxJLPT = value,
              )
            ],
          ),
          PreferenceCategory(
            heading: "Display Options",
            children: [
              SwitchPreference(
                name: "Show readings as Romaji",
                initial: model.readingsAsRomaji,
                onChanged: (value) => model.readingsAsRomaji = value,
              )
            ],
          ),
        ],
      ),
    );
  }
}
