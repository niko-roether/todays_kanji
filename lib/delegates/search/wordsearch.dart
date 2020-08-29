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

class WordSearch extends Search {
  final kanjiSource = KanjiSource();
  final List<String> recent = [];

  WordSearch({String initial = ""}) : super(initial: initial);

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
    super.buildResults(context);
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
    if (query.isEmpty) return;
    recent.insert(0, query);
    while (recent.length > 4) recent.removeLast();
  }
}
