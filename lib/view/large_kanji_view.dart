import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/kanji_view.dart';
import 'package:todays_kanji/view/word_view.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/content_loader.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/inherited/kanji_updater.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';
import 'package:todays_kanji/widgets/large_view_layout.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

class LargeKanjiView extends StatelessWidget {
  final KanjiModel model;
  final bool canReroll;
  final kanjiSource = KanjiSource();
  LargeKanjiView(this.model, {this.canReroll = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<AppState>(builder: (context, state, child) {
      final kanjiUpdater = KanjiUpdater.of(context);

      Widget kunyomi;
      Widget onyomi;
      if (state.preferences.readingsAsRomaji) {
        kunyomi = Text(model.kunyomi.map((e) => kanaToRomaji(e)).join(", "));
        onyomi = Text(model.onyomi.map((e) => kanaToRomaji(e)).join(", "));
      } else {
        kunyomi = JapaneseText(model.kunyomi.join("、"));
        onyomi = JapaneseText(model.onyomi.join("、"));
      }

      List<Widget> annotations = [];
      if (model.frequency != null)
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
          Builder(builder: (context) {
            return InfoCard(
              heading: "Pronunciation",
              contentIndent: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  model.kunyomi.length > 0
                      ? Flexible(child: kunyomi)
                      : Container(),
                  model.onyomi.length > 0
                      ? Flexible(child: onyomi)
                      : Container()
                ],
              ),
            );
          }),
          InfoCard(
            contentIndent: 20,
            heading: "Radical",
            child: ContentLoader<KanjiModel>(
              future: kanjiSource.getKanji(model.radical),
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
          Builder(builder: (BuildContext context) {
            if (model.strokeOrderGifUrl == null) return Container();
            return InfoCard(
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
                          //TODO alt load diagram?
                          return Text("Failed to load stroke order gif.");
                        },
                      ),
                      // TODO add alternatives
                    ],
                  ),
                ),
              ),
            );
          }),
          Builder(builder: (BuildContext context) {
            var wordList = <Widget>[];
            if (model.examples == null) return Container();
            for (var word in model.examples) {
              wordList.add(Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: WordView(
                  word,
                  partition: false,
                  readingsAsRomaji: state.preferences.readingsAsRomaji,
                ),
              ));
            }
            wordList.removeLast();
            if (wordList.length == 0) return Container();
            return InfoCard(
              heading: "Examples",
              contentIndent: 20,
              child: Column(
                children: wordList,
              ),
            );
          }),
        ],
        stackItems: [
          Builder(
            builder: (context) {
              if (!canReroll) return Container();
              return IconButton(
                icon: Icon(Icons.refresh),
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
              );
            },
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
    });
  }
}
