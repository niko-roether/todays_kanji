import "package:http/http.dart" as http;
import 'package:todays_kanji/util/errors.dart';

const _HIRAGANA_KATAKANE_CP_DIFF = 96;
const _BASE_URL = "https://jisho.org/search/";

class KanjiPage {
  static const KANJI_PER_PAGE = 20;
  // ignore: non_constant_identifier_names
  static final RegExp NUM_KANJI = RegExp(
      "<span class=\"result_count\"> ?— ([0-9]+) found<\\/span>",
      caseSensitive: false);
  // ignore: non_constant_identifier_names
  static final RegExp KANJI = RegExp(
      "<span class=\"character.*\"><a .*>(.)<\\/a><\\/span>",
      caseSensitive: false);

  final int numKanji;
  final List<String> kanji;

  KanjiPage({this.numKanji, this.kanji});

  factory KanjiPage.fromHTML(String html) {
    RegExpMatch match = NUM_KANJI.firstMatch(html);
    if (match == null) throw InvalidAPIResponseError(html);
    var numKanji = int.parse(match.group(1));
    var kanji = <String>[];
    for (RegExpMatch match in KANJI.allMatches(html)) {
      kanji.add(match.group(1));
    }
    return KanjiPage(kanji: kanji, numKanji: numKanji);
  }
}

Future<KanjiPage> kanjiSearch(String query, int page) async {
  query = query.trim();
  if (page < 1) throw InvalidAPIRequest("Can't get page $page");
  final url = "$_BASE_URL$query #kanji?page=$page".replaceAll("#", "%23");
  final res = await http.get(url);
  // FIXME assumes res to be good when statusCode = 200
  if (res.statusCode != 200) throw KanjiNotFoundError(query);
  try {
    return KanjiPage.fromHTML(res.body);
  } on InvalidAPIResponseError {
    throw KanjiNotFoundError(query);
  }
}

// terrible solution, inputting non-katakana is UB
String katakanaToHiragana(String katakana) {
  return katakana.runes
      .map((c) => c - _HIRAGANA_KATAKANE_CP_DIFF)
      .toList()
      .fold<String>("", (String s, int p) => s += String.fromCharCode(p));
}
