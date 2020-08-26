import 'package:flutter/material.dart';

import '../annotation.dart';

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
