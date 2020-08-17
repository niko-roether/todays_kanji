import 'package:flutter/foundation.dart';

class WordFormModel {
  final String word;
  final String reading;

  WordFormModel({@required this.word, @required this.reading});
}

class WordSenseModel {
  final List<String> definitions;
  final List<String> wordtypes;
  final List<String> info;
  final List<String> appliesTo;
  final String url;

  WordSenseModel({
    @required this.definitions,
    this.wordtypes,
    this.info,
    this.appliesTo,
    this.url,
  });
}

class WordModel {
  final int jlpt;
  final bool common;
  final List<WordSenseModel> senses;
  final List<WordFormModel> forms;

  WordModel({
    this.jlpt,
    this.common = false,
    @required this.senses,
    @required this.forms,
  });
}
