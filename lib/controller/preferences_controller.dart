import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/util/general.dart';

class PreferencesController {
  final PreferencesModel model;
  PreferencesController(this.model);

  void setMaxJLPT(int maxJLPT) {
    model.maxJLPT = maxJLPT;
  }

  void setKanjiSymbol(String kanji) {
    model.kanjiTimestamp = todayTimestamp();
    model.kanjiSymbol = kanji;
  }

  void setRerollInterval(Duration interval) {
    model.rerollInterval = interval.inMilliseconds;
  }

  void setReadingsAsRomaji(bool value) {
    model.readingsAsRomaji = value;
  }
}
