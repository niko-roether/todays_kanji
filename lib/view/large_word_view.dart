import 'package:flutter/material.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';
import 'package:todays_kanji/widgets/large_view_layout.dart';

class LargeWordView extends StatelessWidget {
  final WordModel model;

  LargeWordView(this.model);

  @override
  Widget build(BuildContext context) {
    List<Widget> annotations = [];
    if (model.common) annotations.add(Annotation("common"));
    if (model.jlpt > 0) annotations.add(JLPTAnnotation(model.jlpt));
    return LargeViewLayout(
      focus: Column(
        children: [
          Row(
            children: annotations,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          JapaneseText(
            model.forms[0].word,
            style: TextStyle(fontSize: 60),
          ),
        ],
      ),
      subfocus: JapaneseText(model.forms[0].reading),
      stackAlign: Alignment.topCenter,
      cards: [
        //TODO add cards
      ],
    );
  }
}
