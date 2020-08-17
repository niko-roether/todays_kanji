import 'package:flutter/material.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/large_word_view.dart';
import 'package:todays_kanji/widgets/content_loader.dart';

class WordScreen extends StatelessWidget {
  static const ROUTENAME = "/word";
  final kanjiSource = KanjiSource();

  @override
  Widget build(BuildContext context) {
    final String word = cast<String>(ModalRoute.of(context).settings.arguments);

    if (word == null) {
      showError(
        context,
        "The supplied word was null or of invalid type",
        onClose: () => Navigator.pop(context),
      );
      return Container();
    }

    Future<WordModel> modelFuture = kanjiSource.getWord(word);

    return Scaffold(
      appBar: AppBar(title: Text("View Kanji $word")),
      body: SizedBox.expand(
        child: ContentLoader<WordModel>(
          future: modelFuture,
          builder: (context, model) {
            return LargeWordView(model);
          },
        ),
      ),
    );
  }
}
