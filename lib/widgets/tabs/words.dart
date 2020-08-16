import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todays_kanji/app_state.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
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
  static const int _WORDS_PER_RELOAD = 10;
  final _kanjiSource = KanjiSource();
  final _controller = ScrollController();
  List<WordView> _words = [];
  bool _loading = false;
  String _loadedKanji;

  Future<List<WordView>> _fetchWords(
    String character, {
    int numWords = _WORDS_PER_RELOAD,
  }) async {
    List<WordModel> models = await _kanjiSource.searchWords(
      "*$character*",
      limit: numWords,
      startIndex: _words.length,
    );
    return models.map<WordView>((e) => WordView(e)).toList();
  }

  Future<void> _loadWords(
    String character, {
    int numWords = _WORDS_PER_RELOAD,
  }) async {
    if (!_loading) {
      setState(() => _loading = true);
      List<WordView> views = await _fetchWords(character, numWords: numWords);
      setState(() {
        _words.addAll(views);
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<AppState>(
      builder: (context, state, child) {
        if (state.loadingKanji) return LoadingIndicator();
        var character = state.preferences.kanjiSymbol;
        if (!_loading && (_loadedKanji != character || _words.length == 0)) {
          _words = [];
          _loading = true;
          _fetchWords(character).then(
            (value) => setState(() {
              _words = value;
              _loadedKanji = character;
              _loading = false;
            }),
          );
        }

        _controller.addListener(() {
          if (!_loading &&
              _controller.position.pixels >
                  _controller.position.maxScrollExtent + 50)
            _loadWords(_loadedKanji);
        });

        var children = _words.map<Widget>((e) => InfoCard(child: e)).toList();
        if (_loading) {
          if (children.length == 0) return LoadingIndicator();
          children.add(LoadingIndicator());
        }
        return ListView(children: children, controller: _controller);
      },
    );

    // String kanjiSymbol = state.preferences.kanjiSymbol;
    // Future<List<WordView>> initialWords = _words.length == 0
    //     ? _fetchWords(kanjiSymbol).then((value) => _words = value)
    //     : Future.value(_words);
    // return ContentLoader<List<WordView>>(
    //   future: initialWords,
    //   builder: (words) {
    //     var children =
    //         words.map<Widget>((e) => InfoCard(child: e)).toList();
    //     if (_loading) {
    //       if (children.length == 0) return LoadingIndicator();
    //       children.add(LoadingIndicator());
    //     }
    //     return ListView(
    //       children: children,
    //       controller: _controller
    //         ..addListener(() {
    //           if (_controller.position.pixels >
    //               _controller.position.maxScrollExtent + 50)
    //             _loadWords(kanjiSymbol);
    //         }),
    //     );
    //   },
    // );
  }

  @override
  bool get wantKeepAlive => true;
}

// FIXME absolutely broken
// class _WordsTabState extends State<WordsTab>
//     with AutomaticKeepAliveClientMixin {
//   static const int _wordsPerLoad = 10;
//   bool loading = true;
//   bool loadedAll = false;
//   String kanjiSymbol;
//   List<WordView> words = [];
//   final controller = ScrollController();
//   final kanjiSource = KanjiSource();

//   // TODO export to new View?
//   Future<void> _loadWords(String character,
//       {int numWords = _wordsPerLoad}) async {
//     List<WordModel> models = await kanjiSource.searchWords(
//       "*$character*",
//       limit: numWords,
//       startIndex: words.length,
//     );
//     if (models.length < numWords) loadedAll = true;
//     setState(() => words.addAll(models.map((m) => WordView(m))?.toList()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppState>(
//       builder: (context, state, child) {
//         PreferencesModel prefs = state.preferences;
//         if (state.loadingKanji) return LoadingIndicator();
//         if (prefs.kanjiSymbol != kanjiSymbol) {
//           words = [];
//           kanjiSymbol = prefs.kanjiSymbol;
//         }
//         if (words.length == 0)
//           _loadWords(prefs.kanjiSymbol).then((value) => setState(() {
//                 loading = false;
//               }));
//         controller.addListener(() async {
//           if (controller.position.pixels >
//               controller.position.maxScrollExtent) {
//             if (loading || loadedAll) return;
//             setState(() => loading = true);
//             await _loadWords(prefs.kanjiSymbol);
//             setState(() => loading = false);
//           }
//         });

//         List<Widget> children =
//             words.map<Widget>((e) => InfoCard(child: e)).toList();
//         if (loading) {
//           if (children.length == 0) return LoadingIndicator();
//           children.add(LoadingIndicator());
//         }

//         super.build(context);
//         return ListView(
//           controller: controller,
//           children: children,
//         );
//       },
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
