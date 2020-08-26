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
  final _kanjiSource = KanjiSource();
  final _controller = ScrollController();
  List<WordView> _words = [];
  int _loadedPages = 0;
  bool _loading = false;
  String _loadedKanji;

  Future<List<WordView>> _fetchWords(
    String character, {
    bool readingsAsRomaji = false,
  }) async {
    List<WordModel> models =
        await _kanjiSource.searchWords("*$character*", page: _loadedPages);
    _loadedPages++;
    return models.map<WordView>((e) => WordView(e)).toList();
  }

  Future<void> _loadWords(
    String character, {
    bool readingsAsRomaji = false,
  }) async {
    if (!_loading) {
      setState(() => _loading = true);
      List<WordView> views = await _fetchWords(
        character,
        readingsAsRomaji: readingsAsRomaji,
      );
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
          _loadedPages = 0;
          _loading = true;
          _fetchWords(character,
                  readingsAsRomaji: state.preferences.readingsAsRomaji)
              .then(
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
            _loadWords(_loadedKanji,
                readingsAsRomaji: state.preferences.readingsAsRomaji);
        });

        var children = _words.map<Widget>((e) => InfoCard(child: e)).toList();
        if (_loading) {
          if (children.length == 0) return LoadingIndicator();
          children.add(LoadingIndicator());
        }
        return ListView(children: children, controller: _controller);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
