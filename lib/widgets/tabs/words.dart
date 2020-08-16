import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/preferences_model.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/view/word_view.dart';
import 'package:todays_kanji/widgets/info_card.dart';
import 'package:todays_kanji/widgets/loading_indicator.dart';

class WordsTab extends StatefulWidget {
  WordsTab({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WordsTabState();
  }
}

class _WordsTabState extends State<WordsTab>
    with AutomaticKeepAliveClientMixin {
  static const int _wordsPerLoad = 10;
  bool _loading = false;
  bool _loadedAll = false;
  final _controller = ScrollController();
  final _kanjiSource = KanjiSource();
  List<WordView> _words = [];

  // TODO export to new View?
  void _loadWords(String character, {int numWords = _wordsPerLoad}) async {
    if (_loading || _loadedAll) return;
    _loading = true;
    List<WordModel> models = await _kanjiSource.searchWords(
      "*$character*",
      limit: numWords,
      startIndex: _words.length,
    );
    if (models.length < numWords) _loadedAll = true;
    setState(() => _words.addAll(models.map((m) => WordView(m))?.toList()));
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        PreferencesModel prefs = state.preferences;
        if (state.loadingKanji) return LoadingIndicator();
        _loadWords(prefs.kanjiSymbol);
        _controller.addListener(() {
          if (_controller.position.atEdge && _controller.position.pixels > 0) {
            _loadWords(prefs.kanjiSymbol);
          }
        });

        List<Widget> children =
            _words.map<Widget>((e) => InfoCard(child: e)).toList();
        if (_loading) {
          if (children.length == 0) return LoadingIndicator();
          children.add(LoadingIndicator());
        }

        super.build(context);
        return ListView(
          controller: _controller,
          children: children,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
