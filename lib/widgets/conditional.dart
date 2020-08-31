import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool condition;
  final Widget child;

  Conditional({this.condition, this.child});

  @override
  Widget build(BuildContext context) => condition ? child : Container();
}
