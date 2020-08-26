import 'package:flutter/material.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/screens/kanji.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/annotations/jlpt_annotation.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';

class KanjiView extends StatelessWidget {
  final KanjiModel model;

  KanjiView(this.model);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<Widget> annotations = [];
    if (model.frequency > 0)
      annotations.add(Annotation("${model.frequency}/2500"));
    if (model.jlpt > 0) annotations.add(JLPTAnnotation(model.jlpt));
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(children: [
              JapaneseText(model.character, style: theme.textTheme.headline3),
              SizedBox(width: 16, height: 0),
              Flexible(
                child: Text(model.meaning.join(", ")),
              ),
            ]),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: annotations,
            crossAxisAlignment: CrossAxisAlignment.end,
          )
        ],
      ),
      onTap: () => Navigator.pushNamed(
        context,
        KanjiScreen.ROUTENAME,
        arguments: KanjiScreenArguments(kanji: model.character),
      ),
    );
  }
}
