import 'package:flutter/material.dart';
import 'package:todays_kanji/widgets/preference.dart';

class SwitchPreference extends StatelessWidget {
  final String name;
  final bool initial;
  final void Function(bool value) onChanged;
  SwitchPreference({
    this.name,
    this.initial,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Preference(
      name: name,
      child: Switch(
        value: initial,
        onChanged: onChanged,
      ),
    );
  }
}
