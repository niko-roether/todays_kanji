import 'package:flutter/material.dart';

class JapaneseText extends StatelessWidget {
  final String text;
  final TextStyle style;

  JapaneseText(this.text, {this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style?.apply(fontFamily: "Meiryo") ?? TextStyle(fontFamily: "Meiryo"),
    );
  }
}
