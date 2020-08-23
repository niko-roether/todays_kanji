import 'package:flutter/material.dart';

class Annotation extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle textStyle;

  Annotation(this.text, {this.color, this.textStyle});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var color = this.color ?? theme.primaryColor;
    var textStyle = this.textStyle ?? theme.textTheme.bodyText2;
    return Padding(
      padding: EdgeInsets.all(4),
      child: Chip(
        label: Text(text, style: textStyle),
        backgroundColor: color,
        elevation: 2,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class JLPTAnnotation extends StatelessWidget {
  final int level;
  JLPTAnnotation(this.level);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var color = theme.indicatorColor;
    return Annotation(
      "N$level",
      color: color,
      textStyle: theme.accentTextTheme.bodyText2,
    );
  }
}
