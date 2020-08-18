import 'package:flutter/foundation.dart';

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
