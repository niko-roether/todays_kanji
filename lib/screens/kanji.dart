import 'package:flutter/material.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/large_kanji_view.dart';
import 'package:todays_kanji/widgets/content_loader.dart';

class KanjiScreen extends StatelessWidget {
  static const ROUTENAME = "/kanji";

  final kanjiSource = KanjiSource();

  @override
  Widget build(BuildContext context) {
    //Maybe add option to use KanjiModel instead of String?
    final String kanjiSymbol =
        cast<String>(ModalRoute.of(context).settings.arguments);

    if (kanjiSymbol == null) {
      showError(
        context,
        "The supplied kanji symbol was null or of invalid type",
        onClose: () => Navigator.pop(context),
      );
      return Container();
    }

    Future<KanjiModel> modelFuture = kanjiSource.getKanji(kanjiSymbol);

    return ScrollConfiguration(
      behavior: RubberBandScroll(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("View Kanji"),
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: ContentLoader<KanjiModel>(
            future: modelFuture,
            builder: (context, model) {
              return LargeKanjiView(model);
            },
          ),
        ),
      ),
    );
  }
}
