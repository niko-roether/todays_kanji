import 'package:flutter/material.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/large_word_view.dart';
import 'package:todays_kanji/widgets/content_loader.dart';
import 'package:todays_kanji/widgets/default_app_bar.dart';

class WordScreenArguments {
  final String word;
  final String pronunciation;

  WordScreenArguments({@required this.word, this.pronunciation})
      : assert(word != null);
}

class WordScreen extends StatelessWidget {
  static const ROUTENAME = "/word";
  final kanjiSource = KanjiSource();

  @override
  Widget build(BuildContext context) {
    final args =
        cast<WordScreenArguments>(ModalRoute.of(context).settings.arguments);

    if (args == null) {
      showError(
        context,
        "The supplied arguments were null or of invalid type",
        onClose: () => Navigator.pop(context),
      );
      return Container();
    }

    return ScrollConfiguration(
      behavior: RubberBandScroll(),
      child: Scaffold(
        appBar: DefaultAppBar(header: Text("View Word")),
        body: SizedBox.expand(
          child: ContentLoader<WordModel>(
            futureCallback: () => kanjiSource.getWord(
              args.word,
              pronunciation: args.pronunciation,
            ),
            builder: (context, model) {
              return LargeWordView(model);
            },
          ),
        ),
      ),
    );
  }
}
