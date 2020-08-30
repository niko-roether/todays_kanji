import 'package:flutter/material.dart';
import 'package:todays_kanji/delegates/search/wordsearch.dart';
import 'package:todays_kanji/widgets/search_button.dart';

class WordSearchButton extends StatelessWidget {
  final wordSearch = WordSearch();

  @override
  Widget build(BuildContext context) {
    return SearchButton(
      searchDelegate: wordSearch,
    );
  }
}
