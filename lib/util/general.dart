import 'package:flutter/material.dart';
import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/widgets/error_display.dart';
import 'package:todays_kanji/util/kana_romaji_mapping.dart';

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

const _KANJI_CP_START = 19968;
const _KANJI_CP_END = 40895;
bool isKanji(String char) {
  if (char.length > 1) return false;
  int cp = char.codeUnitAt(0);
  return _KANJI_CP_START <= cp && cp <= _KANJI_CP_END;
}

String kanaToRomaji(String kana) {
  String romaji = kana.split("").map((e) {
    if (!HIRAGANA_ROMAJI_MAPPING.containsKey(e)) return e;
    return HIRAGANA_ROMAJI_MAPPING[e];
  }).join("");
  for (int i = romaji.indexOf("x"); i != -1; i = romaji.indexOf("x")) {
    romaji = romaji.substring(0, i - 1) + romaji.substring(i + 1);
  }
  for (int i = romaji.indexOf("_"); i != -1; i = romaji.indexOf("_")) {
    romaji = romaji.substring(0, i) +
        romaji.substring(i + 1, i + 2) +
        romaji.substring(i + 1);
  }
  return romaji;
}
