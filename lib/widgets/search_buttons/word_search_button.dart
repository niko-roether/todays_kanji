import 'package:flutter/cupertino.dart';
import 'package:todays_kanji/delegates/search/wordsearch.dart';
import 'package:todays_kanji/widgets/search_button.dart';

class WordSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchButton(searchDelegate: WordSearch());
  }
}
