import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/screens/word_list.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/kanji_view.dart';
import 'package:todays_kanji/view/word_view.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/annotations/jlpt_annotation.dart';
import 'package:todays_kanji/widgets/conditional.dart';
import 'package:todays_kanji/widgets/content_loader.dart';
import 'package:todays_kanji/widgets/data_conditional.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/inherited/kanji_updater.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';
import 'package:todays_kanji/widgets/large_view_layout.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

import '../app_state.dart';

// TODO extract widgets
class LargeKanjiView extends StatelessWidget {
  final KanjiModel model;
  final bool isMain;
  final kanjiSource = KanjiSource();
  LargeKanjiView(this.model, {this.isMain = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final kanjiUpdater = KanjiUpdater.of(context);

    List<Widget> annotations = [];
    if (model.frequency > 0)
      annotations.add(Annotation("${model.frequency}/2500"));
    if (model.jlpt > 0) annotations.add(JLPTAnnotation(model.jlpt));

    return LargeViewLayout(
      focus: JapaneseText(
        model.character,
        style: TextStyle(fontSize: 150),
      ),
      subfocus: Text(
        model.meaning.join(", "),
        style: theme.textTheme.subtitle1,
        textAlign: TextAlign.center,
      ),
      cards: [
        Consumer<AppState>(builder: (context, state, child) {
          Widget kunyomi;
          Widget onyomi;
          if (state.preferences.readingsAsRomaji) {
            kunyomi =
                Text(model.kunyomi.map((e) => kanaToRomaji(e)).join(", "));
            onyomi = Text(model.onyomi.map((e) => kanaToRomaji(e)).join(", "));
          } else {
            kunyomi = JapaneseText(model.kunyomi.join("、"));
            onyomi = JapaneseText(model.onyomi.join("、"));
          }
          return InfoCard(
            heading: "Pronunciation",
            contentIndent: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Conditional(
                  condition: model.kunyomi.length > 0,
                  child: Flexible(child: kunyomi),
                ),
                Conditional(
                  condition: model.onyomi.length > 0,
                  child: Flexible(child: onyomi),
                ),
              ],
            ),
          );
        }),
        InfoCard(
          contentIndent: 20,
          heading: "Radical",
          child: ContentLoader<KanjiModel>(
            futureCallback: () => kanjiSource.getKanji(model.radical),
            builder: (context, radical) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KanjiView(radical),
                    Text("Other parts: " + model.parts.join(", ")),
                  ],
                ),
              );
            },
          ),
        ),
        Conditional(
          condition: model.strokeOrderGifUrl != null,
          child: InfoCard(
            heading: "Stroke Order",
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      model.strokeOrderGifUrl,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null)
                          return child;
                        return LoadingIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Text("Failed to load stroke order gif.");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        DataConditional<List<Widget>>(
          dataGetter: (context) {
            var wordList = <Widget>[];
            if (model.examples == null) return null;
            for (var word in model.examples)
              wordList.add(Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: WordView(word, partition: false),
              ));
            return wordList;
          },
          condition: (data) => data != null && data.length > 0,
          builder: (BuildContext context, List<Widget> wordList) {
            wordList.removeLast();
            return InfoCard(
              heading: "Examples",
              contentIndent: 20,
              child: Column(
                children: [
                  ...wordList,
                  Conditional(
                    condition: !isMain,
                    child: FlatButton(
                      color: theme.accentColor,
                      textColor: theme.accentTextTheme.bodyText2.color,
                      child: Text("More Words"),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        WordListScreen.ROUTENAME,
                        arguments:
                            WordListArguments(query: "*${model.character}*"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      stackItems: [
        Conditional(
          condition: isMain,
          child: IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Reroll Kanji",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Confirm Reroll"),
                    content: SingleChildScrollView(
                      child: Text(
                        "Are you shure you want to reroll your daily kanji?",
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text("REROLL"),
                        onPressed: () {
                          kanjiUpdater.reroll();
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("CANCEL"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: annotations,
          ),
        ),
      ],
    );
  }
}
