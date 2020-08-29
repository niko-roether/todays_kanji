import 'package:todays_kanji/controller/preferences_controller.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todays_kanji/delegates/search.dart';
import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/model/word_form_model.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/model/word_sense_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/widgets/dynamic_lists/word_list.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

class WordSearch extends Search {
  final kanjiSource = KanjiSource();
  final PreferencesController prefController;

  WordSearch({String initial = "", this.prefController})
      : super(initial: initial);

  List<String> _getSuggestableTerms(WordModel model) {
    List<String> terms = [];
    for (WordFormModel form in model.forms) {
      if (form.reading != null) terms.add(form.reading);
      if (form.word != null) terms.add(form.word);
      if (form.readingRomaji != null) terms.add(form.readingRomaji);
    }
    for (WordSenseModel sense in model.senses) terms.addAll(sense.definitions);
    return removeDuplicates(terms);
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.expand(child: WordList(query: query));
  }

  @override
  FutureOr<List<String>> fetchSuggestions() async {
    List<WordModel> models = await kanjiSource.searchWords(query);
    List<String> suggestions = [];
    for (WordModel model in models)
      suggestions.addAll(_getSuggestableTerms(model)
          .where((element) => element.startsWith(query)));
    return removeDuplicates(suggestions);
  }

  @override
  void addRecentSearch(String query) {
    if (prefController != null) prefController.addWordSearch(query);
  }
}
