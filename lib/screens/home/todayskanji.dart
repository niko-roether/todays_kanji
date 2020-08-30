import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/view/large_kanji_view.dart';
import 'package:todays_kanji/widgets/content_loader.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

class TodaysKanjiTab extends StatefulWidget {
  TodaysKanjiTab({Key key}) : super(key: key);

  @override
  State<TodaysKanjiTab> createState() {
    return _TodaysKanjiTabState();
  }
}

class _TodaysKanjiTabState extends State<TodaysKanjiTab>
    with AutomaticKeepAliveClientMixin {
  final _kanjiSource = KanjiSource();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<AppState>(
      builder: (context, state, child) {
        PreferencesModel prefs = state.preferences;
        if (state.loadingKanji) return LoadingIndicator();
        return ContentLoader<KanjiModel>(
          futureCallback: () => _kanjiSource.getKanji(prefs.kanjiSymbol),
          builder: (context, KanjiModel data) {
            if (data == null) return Container();
            return LargeKanjiView(data, isMain: true);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
