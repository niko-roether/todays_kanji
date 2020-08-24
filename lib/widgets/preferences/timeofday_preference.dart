import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todays_kanji/widgets/preference.dart';

class TimeOfDayPreference extends StatefulWidget {
  final String name;
  final TimeOfDay value;
  final void Function(TimeOfDay time) onChanged;

  TimeOfDayPreference({this.name, this.value, this.onChanged});

  @override
  State<TimeOfDayPreference> createState() {
    return _TimeOfDayPreferenceState(value);
  }
}

class _TimeOfDayPreferenceState extends State<TimeOfDayPreference> {
  TimeOfDay current;

  _TimeOfDayPreferenceState(this.current);

  @override
  Widget build(BuildContext context) {
    // TODO add AM / PM
    int hour = current.hour;
    int minute = current.minute;
    return Preference(
      name: widget.name,
      child: InkWell(
        onTap: () async {
          TimeOfDay newTime = await showTimePicker(
            context: context,
            initialTime: current,
          );
          setState(() {
            current = newTime;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).buttonColor, width: 2),
            ),
          ),
          child: Text("$hour:$minute"),
        ),
      ),
    );
  }
}
