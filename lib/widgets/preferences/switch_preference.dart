import 'package:flutter/material.dart';
import 'package:todays_kanji/widgets/preference.dart';

class SwitchPreference extends StatefulWidget {
  final String name;
  final bool initial;
  final void Function(bool value) onChanged;

  SwitchPreference({
    this.name,
    this.initial,
    @required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _SwitchPreferenceState(initial);
  }
}

class _SwitchPreferenceState extends State<SwitchPreference> {
  bool value;
  _SwitchPreferenceState(this.value);

  @override
  Widget build(BuildContext context) {
    return Preference(
      name: widget.name,
      child: Switch(
        value: value,
        onChanged: (newValue) {
          setState(() => value = newValue);
          widget.onChanged(value);
        },
      ),
    );
  }
}
