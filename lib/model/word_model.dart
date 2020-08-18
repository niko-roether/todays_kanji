import 'package:flutter/foundation.dart';
import 'package:todays_kanji/model/word_form_model.dart';
import 'package:todays_kanji/model/word_sense_model.dart';

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
