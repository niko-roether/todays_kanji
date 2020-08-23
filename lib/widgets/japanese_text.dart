import 'package:flutter/material.dart';

class JapaneseText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  JapaneseText(this.text, {this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style:
          style?.apply(fontFamily: "Meiryo") ?? TextStyle(fontFamily: "Meiryo"),
    );
  }
}
