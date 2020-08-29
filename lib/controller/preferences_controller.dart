import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/util/general.dart';

class PreferencesController {
  final PreferencesModel model;
  PreferencesController(this.model);

  void setKanjiSymbol(String kanji) {
    model.kanjiTimestamp = todayTimestamp();
    model.kanjiSymbol = kanji;
  }

  void addWordSearch(String query) {
    model.recentWordSearches.add(query);
  }
}
