import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "package:url_launcher/url_launcher.dart";

class Weblink extends StatelessWidget {
  final String text;
  final String url;

  Weblink({this.text, this.url});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: theme.buttonColor,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launch(url);
          },
      ),
    );
  }
}
