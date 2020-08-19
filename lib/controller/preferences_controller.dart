import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/util/general.dart';

class PreferencesController {
  final _kanjiSource = KanjiSource();
  final PreferencesModel model;
  PreferencesController(this.model);

  void setMaxJLPT(int maxJLPT) {
    model.maxJLPT = maxJLPT;
  }

  void setKanjiSymbol(String kanji) {
    model.kanjiTimestamp = todayTimestamp();
    model.kanjiSymbol = kanji;
  }
}
