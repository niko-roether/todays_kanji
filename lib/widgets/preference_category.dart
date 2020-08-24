import 'package:flutter/material.dart';

class PreferenceCategory extends StatelessWidget {
  final String heading;
  final List<Widget> children;
  PreferenceCategory({this.heading, this.children});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> children = <Widget>[
      Text(heading, style: theme.textTheme.headline6)
    ]..addAll(this.children);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
