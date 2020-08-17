import 'package:flutter/material.dart';

class KanjiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Maybe add option to use KanjiModel instead of String?
    final String kanjiSymbol = ModalRoute.of(context).settings.arguments;
  }
}
