import 'package:flutter/cupertino.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/view/word_view.dart';
import 'package:todays_kanji/widgets/dynamic_list.dart';

import '../info_card.dart';

class WordList extends StatelessWidget {
  final String query;
  final _kanjiSource = KanjiSource();

  WordList({@required this.query}) : assert(query != null);

  @override
  Widget build(BuildContext context) {
    return DynamicList(loader: (context, index) async {
      return Column(
        children: await _kanjiSource.searchWords(query, page: index).then(
            (words) => words.map((e) => InfoCard(child: WordView(e))).toList()),
      );
    });
  }
}
