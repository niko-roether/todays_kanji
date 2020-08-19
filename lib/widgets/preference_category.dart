import 'package:flutter/cupertino.dart';
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
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
