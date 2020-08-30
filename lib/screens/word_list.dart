import 'package:flutter/material.dart';
import 'package:todays_kanji/util/dynamic_screen.dart';
import 'package:todays_kanji/widgets/default_app_bar.dart';
import 'package:todays_kanji/widgets/dynamic_lists/word_list.dart';
import 'package:todays_kanji/widgets/screen.dart';

class WordListArguments {
  final String query;

  WordListArguments(this.query);
}

class WordListScreen extends StatelessWidget
    with DynamicScreen<WordListArguments> {
  static const ROUTENAME = "/word_list";

  @override
  Widget build(BuildContext context) {
    WordListArguments args = getArguments(context);

    return Screen(
      appBar: DefaultAppBar(header: Text("Word List")),
      child: WordList(query: args.query),
    );
  }
}
