import 'package:flutter/material.dart';
import 'package:todays_kanji/model/kanji_model.dart';

T cast<T>(x) => x is T ? x : null;

int todayTimestamp() {
  var now = DateTime.now().millisecondsSinceEpoch;
  return now - now % 86400000;
}

class RubberBandScroll extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}

class NewKanjiModelFuture extends ChangeNotifier {
  final Future<KanjiModel> future;
  NewKanjiModelFuture(this.future);
}
