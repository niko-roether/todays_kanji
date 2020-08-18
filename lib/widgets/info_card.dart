import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  static const double DEFAULT_INDENT = 8;
  final Widget child;
  final String heading;
  final double contentIndent;
  final CrossAxisAlignment contentCrossAxisAlignment;

  InfoCard({
    this.heading,
    this.child,
    this.contentIndent = DEFAULT_INDENT,
    this.contentCrossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var content = <Widget>[];
    if (heading != null) {
      content.add(Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Text(
          this.heading,
          style: theme.textTheme.headline6,
        ),
      ));
      content.add(Divider());
    }
    if (child != null) {
      content.add(
        Padding(
          padding: EdgeInsets.fromLTRB(contentIndent, 2, contentIndent, 16),
          child: child,
        ),
      );
    }
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 5,
      child: Column(
        crossAxisAlignment: contentCrossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
    );
  }
}
