import 'package:flutter/foundation.dart';
import "package:todays_kanji/model/word_model.dart";

class KanjiModel {
  final String character;
  final int jlpt;
  final List<String> radicalForms;
  final List<String> meaning;
  final int frequency;
  final List<String> kunyomi;
  final List<String> onyomi;
  final List<WordModel> examples;
  final String radical;
  final List<String> parts;
  final String strokeOrderGifUrl;

  KanjiModel({
    @required this.character,
    this.jlpt = 0, // 0 if none
    this.radicalForms,
    @required this.meaning,
    this.frequency = 0, // 0 if none
    this.kunyomi = const [],
    this.onyomi = const [],
    this.examples = const [],
    this.radical,
    this.parts,
    this.strokeOrderGifUrl,
  })  : assert(character != null),
        assert(jlpt != null),
        assert(meaning != null),
        assert(frequency != null),
        assert(kunyomi != null),
        assert(onyomi != null),
        assert(examples != null);
}
