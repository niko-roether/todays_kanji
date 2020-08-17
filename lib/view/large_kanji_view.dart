import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/controller/preferences_controller.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/view/word_view.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/japanese_text.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

class LargeKanjiView extends StatelessWidget {
  final KanjiModel model;
  final PreferencesController controller;
  LargeKanjiView(this.model, this.controller);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = Provider.of<AppState>(context);
    return Consumer<AppState>(builder: (context, state, child) {
      return ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                IconButton(
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
                                //TODO export this to controller
                                controller.rerollKanjiSymbol();
                                appState.loadingKanji = true;
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
                Align(
                  alignment: Alignment.topRight,
                  child: Builder(builder: (BuildContext context) {
                    var annotations = <Widget>[];
                    if (model.frequency != null) {
                      annotations.add(Annotation(
                        "${model.frequency}/2500",
                      ));
                    }
                    if (model.jlpt != null) {
                      annotations.add(JLPTAnnotation(model.jlpt));
                    }
                    return Column(
                      children: annotations,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    );
                  }),
                ),
                Center(
                  child: Column(
                    children: [
                      JapaneseText(
                        model.character,
                        style: TextStyle(fontSize: 150),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          model.meaning.join(", "),
                          style: theme.textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Builder(builder: (BuildContext context) {
            List<Widget> readings = [];
            if (model.kunyomi.length > 0)
              readings.add(JapaneseText(model.kunyomi.join(", ")));
            if (model.onyomi.length > 0)
              readings.add(JapaneseText(model.onyomi.join(", ")));
            if (readings.length == 0) return Container();
            return InfoCard(
              heading: "Pronunciation",
              contentIndent: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: readings,
              ),
            );
          }),
          Builder(
            builder: (BuildContext context) {
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
                            // return Image.network(
                            //   model.strokeOrderDiagramUrl,
                            //   frameBuilder: (context, child, frame,
                            //       wasSynchronouslyLoaded) {
                            //     if (child != null) return child;
                            //     return LoadingIndicator();
                            //   },
                            //   errorBuilder: (context, error, stackTrace) =>
                            //       Text("Couldn't get stroke order"),
                            // );
                            return Text("Failed to load stroke order gif.");
                          },
                        ),
                        // TODO add alternatives
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
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
            },
          ),
        ],
      );
    });
  }
}
