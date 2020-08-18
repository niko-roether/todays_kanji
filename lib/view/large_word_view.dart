import 'package:flutter/material.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/word_form_view.dart';
import 'package:todays_kanji/view/word_sense_view.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/content_loader.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';
import 'package:todays_kanji/widgets/large_view_layout.dart';

import 'kanji_view.dart';

class LargeWordView extends StatelessWidget {
  final WordModel model;
  final kanjiSource = KanjiSource();

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
        Builder(builder: (context) {
          List<WordSenseView> senses = model.senses
              .asMap()
              .entries
              .map((e) => WordSenseView(e.value, e.key))
              .toList();
          return InfoCard(
            contentIndent: 20,
            heading: "Meanings",
            child: Column(children: senses),
          );
        }),
        Builder(builder: (context) {
          List<WordFormView> forms =
              model.forms.map((e) => WordFormView(e)).toList()..removeAt(0);
          return InfoCard(
            contentIndent: 20,
            heading: "Other Forms",
            child: Column(children: forms),
          );
        }),
        Builder(builder: (context) {
          List<Future<KanjiModel>> futures = model.forms
              .map((e) => e.word)
              .join("")
              .split("")
              .toSet()
              .where((char) => isKanji(char))
              .map((e) => kanjiSource.getKanji(e))
              .toList();
          return InfoCard(
            heading: "Kanji",
            child: ContentLoader(
              future: Future.wait(futures),
              builder: (context, List<KanjiModel> models) {
                return Column(
                  children: models.map((e) => KanjiView(e)).toList(),
                );
              },
            ),
          );
        })
      ],
    );
  }
}
