import 'package:todays_kanji/util/general.dart';

class WordFormModel {
  final String word;
  final String reading;
  final String readingRomaji;

  WordFormModel({
    this.word,
    this.reading,
  })  : assert(word != null || reading != null),
        readingRomaji = kanaToRomaji(reading);
}
