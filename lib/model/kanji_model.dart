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
    this.jlpt,
    this.radicalForms,
    this.meaning,
    this.frequency,
    this.kunyomi,
    this.onyomi,
    this.examples,
    this.radical,
    this.parts,
    this.strokeOrderGifUrl,
  });
}
