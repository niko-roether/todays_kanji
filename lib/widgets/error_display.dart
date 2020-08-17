import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final Widget header;
  final Widget child;

  ErrorDisplay({this.header, this.child});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(26),
        child: Card(
          color: theme.errorColor,
          child: Column(
            children: [
              header,
              child,
            ],
          ),
        ),
      ),
    );
  }
}
