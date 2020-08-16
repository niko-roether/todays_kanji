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

  Future<void> rerollKanjiSymbol() async {
    model.kanjiTimestamp = todayTimestamp();
    model.kanjiSymbol =
        await _kanjiSource.randomKanjiSymbol(maxJlpt: model.maxJLPT);
  }

  Future<void> updateKanjiSymbol({void Function() onReroll}) async {
    int now = DateTime.now().millisecondsSinceEpoch;
    int difference = now - model.kanjiTimestamp;
    if (model.kanjiTimestamp == null || difference > 864000000) {
      if (onReroll != null) onReroll();
      rerollKanjiSymbol();
    }
  }
}
