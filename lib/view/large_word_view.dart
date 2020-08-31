import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/model/word_sense_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/word_form_view.dart';
import 'package:todays_kanji/view/word_sense_view.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/annotations/jlpt_annotation.dart';
import 'package:todays_kanji/widgets/content_loader.dart';
import 'package:todays_kanji/widgets/data_conditional.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';
import 'package:todays_kanji/widgets/large_view_layout.dart';

import '../app_state.dart';
import 'kanji_view.dart';

// TODO extract widgets
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
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 60),
          ),
        ],
      ),
      subfocus: Consumer<AppState>(builder: (context, state, child) {
        String reading = model.forms[0].reading;
        if (state.preferences.readingsAsRomaji)
          return Text(kanaToRomaji(reading));
        return JapaneseText(reading);
      }),
      stackAlign: Alignment.topCenter,
      cards: [
        DataConditional<List<Widget>>(
          dataGetter: (context) {
            return model.senses
                .asMap()
                .entries
                .map((e) => Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: WordSenseView(e.value, e.key),
                    ))
                .toList();
          },
          condition: (data) => data.length > 0,
          builder: (context, senses) {
            return InfoCard(
              contentIndent: 20,
              heading: "Meanings",
              child: Column(
                children: senses,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            );
          },
        ),
        DataConditional<List<Widget>>(
          dataGetter: (context) {
            return model.forms.map((e) => WordFormView(e)).toList()
              ..removeAt(0);
          },
          condition: (data) => data.length > 0,
          builder: (context, forms) {
            return InfoCard(
              contentIndent: 20,
              heading: "Other Forms",
              child: Column(
                children: forms,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            );
          },
        ),
        DataConditional<List<String>>(
          dataGetter: (context) {
            List<String> info = [];
            for (WordSenseModel sense in model.senses) info.addAll(sense.info);
            return info;
          },
          condition: (data) => data.length > 0,
          builder: (context, info) {
            return InfoCard(
              heading: "Info",
              child: Column(
                children: info.map<Widget>((i) => Text(i)).toList(),
              ),
            );
          },
        ),
        InfoCard(
          heading: "Kanji",
          contentIndent: 20,
          child: ContentLoader(
            futureCallback: () {
              List<Future<KanjiModel>> futures = model.forms
                  .map((e) => e.word)
                  .join("")
                  .split("")
                  .toSet()
                  .where((char) => isKanji(char))
                  .map((e) => kanjiSource.getKanji(e))
                  .toList();
              return Future.wait(futures);
            },
            builder: (context, List<KanjiModel> models) {
              return Column(
                children: models
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: KanjiView(e),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
