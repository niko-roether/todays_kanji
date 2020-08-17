import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/controller/preferences_controller.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/view/word_view.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';
import 'package:todays_kanji/widgets/large_view_layout.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

class LargeKanjiView extends StatelessWidget {
  final KanjiModel model;
  LargeKanjiView(this.model);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<AppState>(builder: (context, state, child) {
      var controller = PreferencesController(state.preferences);

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
        annotations: annotations,
        cards: [
          Builder(builder: (context) {
            return InfoCard(
              heading: "Pronunciation",
              contentIndent: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: JapaneseText(model.kunyomi.join("、"))),
                  Flexible(child: JapaneseText(model.onyomi.join("、")))
                ],
              ),
            );
          }),
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
              wordList.add(WordView(word, partition: false));
              wordList.add(Divider());
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
        topLeft: IconButton(
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
                        controller.rerollKanjiSymbol();
                        state.loadingKanji = true;
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("CANCEL"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
      );
    });
  }
}
