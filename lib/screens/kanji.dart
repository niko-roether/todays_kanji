import 'package:flutter/material.dart';
import 'package:todays_kanji/data_source/kanji_source.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/view/large_kanji_view.dart';
import 'package:todays_kanji/widgets/content_loader.dart';
import 'package:todays_kanji/widgets/default_app_bar.dart';
import 'package:todays_kanji/util/dynamic_screen.dart';
import 'package:todays_kanji/widgets/screen.dart';

class KanjiScreenArguments {
  final String kanji;

  KanjiScreenArguments({@required this.kanji}) : assert(kanji != null);
}

class KanjiScreen extends StatelessWidget
    with DynamicScreen<KanjiScreenArguments> {
  static const ROUTENAME = "/kanji";

  final kanjiSource = KanjiSource();

  @override
  Widget build(BuildContext context) {
    KanjiScreenArguments args = getArguments(context);

    return Screen(
      appBar: DefaultAppBar(header: Text("View Kanji")),
      child: ContentLoader<KanjiModel>(
        futureCallback: () => kanjiSource.getKanji(args.kanji),
        builder: (context, model) => LargeKanjiView(model),
      ),
    );
  }
}
