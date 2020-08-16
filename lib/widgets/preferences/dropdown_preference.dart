import 'package:flutter/material.dart';
import 'package:todays_kanji/widgets/preference.dart';

class DropdownPreference<T> extends StatefulWidget {
  final String name;
  final List<DropdownPreferenceItem<T>> items;
  final T initial;
  final String placeholder;
  final void Function(T) onChanged;
  DropdownPreference({
    this.name,
    this.items,
    this.initial,
    this.placeholder,
    @required this.onChanged,
  });

  @override
  State<DropdownPreference> createState() {
    return _DropdownPreferenceState(currentItem: initial, onChanged: onChanged);
  }
}

class _DropdownPreferenceState<T> extends State<DropdownPreference> {
  T currentItem;
  final void Function(T) onChanged;
  _DropdownPreferenceState({this.currentItem, this.onChanged});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Preference(
      name: widget.name,
      child: DropdownButton<T>(
        value: currentItem,
        items: widget.items
            .map((i) => DropdownMenuItem<T>(
                  child: Text(i.text),
                  value: i.value,
                  onTap: () {
                    setState(() => currentItem = i.value);
                  },
                ))
            .toList(),
        hint: Text(widget.placeholder ?? ""),
        onChanged: onChanged,
        underline: Container(
          height: 2,
          color: theme.buttonColor,
        ),
      ),
    );
  }
}

class DropdownPreferenceItem<T> {
  final String text;
  final T value;
  DropdownPreferenceItem({this.text, this.value});
}
