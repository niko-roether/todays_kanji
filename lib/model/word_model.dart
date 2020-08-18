import 'package:flutter/foundation.dart';

class WordFormModel {
  final String word;
  final String reading;

  WordFormModel({
    this.word,
    this.reading,
  }) : assert(word != null || reading != null);
}

class WordSenseModel {
  final List<String> definitions;
  final List<String> wordtypes;
  final List<String> info;
  final List<String> appliesTo;
  final String url;

  WordSenseModel({
    @required this.definitions,
    this.wordtypes = const [],
    this.info = const [],
    this.appliesTo = const [],
    this.url,
  })  : assert(definitions != null),
        assert(wordtypes != null),
        assert(info != null),
        assert(appliesTo != null);
}

class WordModel {
  final int jlpt;
  final bool common;
  final List<WordSenseModel> senses;
  final List<WordFormModel> forms;

  WordModel({
    this.jlpt = 0,
    this.common = false,
    @required this.senses,
    @required this.forms,
  })  : assert(jlpt != null),
        assert(common != null),
        assert(senses != null),
        assert(forms != null);
}
