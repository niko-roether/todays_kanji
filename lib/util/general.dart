import 'package:flutter/material.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/widgets/error_display.dart';

T cast<T>(x) => x is T ? x : null;

int todayTimestamp() {
  var now = DateTime.now().millisecondsSinceEpoch;
  return now - now % 86400000;
}

void showError(BuildContext context, String text, {void Function() onClose}) {
  Future.delayed(Duration.zero, () {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDisplay(child: Text(text));
      },
    ).then((value) => onClose());
  });
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

const _HIRAGANA_KATAKANE_CP_DIFF = 96;
const _KATAKANA_CP_START = 12448;
const _KATAKANA_CP_END = 12543; // inclusive
String katakanaToHiragana(String katakana) {
  return katakana.runes
      .map((c) {
        if (_KATAKANA_CP_START <= c && c <= _KATAKANA_CP_END)
          return c - _HIRAGANA_KATAKANE_CP_DIFF;
        return c;
      })
      .toList()
      .fold<String>("", (String s, int p) => s += String.fromCharCode(p));
}
