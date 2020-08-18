import 'package:flutter/material.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';

class KanjiView extends StatelessWidget {
  final KanjiModel model;

  KanjiView(this.model);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var contextWidth = MediaQuery.of(context).size.width;

    List<Widget> annotations = [];
    if (model.frequency > 0)
      annotations.add(Annotation("${model.frequency}/2500"));
    if (model.jlpt > 0) annotations.add(JLPTAnnotation(model.jlpt));
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            JapaneseText(model.character, style: theme.textTheme.headline3),
            Container(width: 16),
            Container(
              width: contextWidth * 0.45,
              child: Text(model.meaning.join(", ")),
            ),
          ]),
          Column(
            children: annotations,
            crossAxisAlignment: CrossAxisAlignment.end,
          )
        ],
      ),
      onTap: () => Navigator.pushNamed(
        context,
        "/kanji",
        arguments: model.character,
      ),
    );
  }
}
