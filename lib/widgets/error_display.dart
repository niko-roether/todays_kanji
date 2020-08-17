import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final Widget child;

  ErrorDisplay({this.child});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AlertDialog(
      title: Text("An Error Occured"),
      backgroundColor: theme.errorColor,
      content: child,
    );
  }
}
