import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:unofficial_jisho_api/api.dart';
import 'package:unofficial_jisho_api/src/phraseSearch.dart';
import 'package:todays_kanji/util/errors.dart';

const _BASE_URL = "https://jisho.org/search/";
const RESULTS_PER_PAGE = 20;

class ResultPage<T> {
  final int numResults;
  final List<T> results;

  ResultPage({this.numResults, this.results});
}

const NUM_KANJI_PATTERN =
    "<span class=\"result_count\"> ?— ([0-9]+) found<\\/span>";
const KANJI_PATTERN = "<span class=\"character.*\"><a .*>(.)<\\/a><\\/span>";

ResultPage<String> _kanjiPageFromHTML(String html) {
  RegExpMatch numMatch = RegExp(NUM_KANJI_PATTERN).firstMatch(html);
  if (numMatch == null) throw InvalidAPIResponseError(html);
  var numKanji = int.parse(numMatch.group(1));
  List<String> kanji = [];
  for (RegExpMatch kanjiMatch in RegExp(KANJI_PATTERN).allMatches(html)) {
    kanji.add(kanjiMatch.group(1));
  }
  return ResultPage<String>(results: kanji, numResults: numKanji);
}

Future<ResultPage<String>> kanjiSymbolSearch(
  String query, {
  int page = 0,
}) async {
  query = query.trim();
  if (page < 0) throw InvalidAPIRequest("Can't get page $page");
  String url = "$_BASE_URL$query #kanji".replaceAll("#", "%23");
  if (page > 0) url += "?page=${page + 1}";
  final res = await http.get(url);
  // FIXME assumes res to be good when statusCode = 200
  if (res.statusCode != 200) throw KanjiNotFoundError("$query (page $page)");
  return _kanjiPageFromHTML(res.body);
}

Future<ResultPage<JishoResult>> wordSearch(
  String query, {
  int page = 0,
}) async {
  query = query.trim();
  if (page < 0) throw InvalidAPIRequest("Can't get page $page");
  query = uriForPhraseSearch(query);
  if (page > 0) query += "&page=${page + 1}";
  final res = await http.get(query);
  if (res.statusCode != 200) throw WordNotFoundError("$query (page $page)");
  // TODO what about numResults?
  return ResultPage(
    results: JishoAPIResult.fromJson(jsonDecode(res.body)).data,
  );
}
