import 'package:flutter/material.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';

class KanjiView extends StatelessWidget {
  final KanjiModel model;

  KanjiView(this.model);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var contextWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        JapaneseText(model.character, style: theme.textTheme.headline3),
        Container(
          width: contextWidth * 0.8,
          child: Text(model.meaning.join("; ")),
        ),
      ],
    );
  }
}
