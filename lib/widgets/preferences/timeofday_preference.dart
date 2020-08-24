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
    String hour = current.hour.toString();
    while (hour.length < 2) hour = "0" + hour;
    String minute = current.minute.toString();
    while (minute.length < 2) minute = "0" + minute;

    var theme = Theme.of(context);

    return Preference(
      name: widget.name,
      child: InkWell(
        onTap: () async {
          TimeOfDay newTime = await showTimePicker(
            context: context,
            initialTime: current,
          );
          if (newTime == null) return;
          setState(() {
            current = newTime;
          });
          widget.onChanged(newTime);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.buttonColor, width: 2),
            ),
          ),
          child: Row(children: [
            Text("$hour:$minute", style: theme.textTheme.subtitle1),
            Icon(Icons.arrow_drop_down,
                color:
                    Color.fromARGB(179, 255, 255, 255)) // TODO color from theme
          ]),
        ),
      ),
    );
  }
}
