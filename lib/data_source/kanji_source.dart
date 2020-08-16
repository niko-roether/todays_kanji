import 'dart:math';

import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/util/errors.dart';
import 'package:todays_kanji/util/jisho_helper.dart';
import 'package:unofficial_jisho_api/api.dart' as jisho;
import "package:todays_kanji/util/jisho_helper.dart" as jishoHelper;

class KanjiSearchOptions {
  final int jlpt;
  final bool common;
  final bool joyo;
  final String _queryString;

  const KanjiSearchOptions({this.jlpt, this.common, this.joyo})
      : _queryString = (jlpt != null && jlpt > 0 ? " #jlpt-n$jlpt" : "") +
            (common != null && common ? " #common" : "") +
            (joyo != null && joyo ? " #joyo" : "");
}

class KanjiSource {
  Future<int> numKanji(
    String query, {
    KanjiSearchOptions options = const KanjiSearchOptions(),
  }) async {
    query += options._queryString;
    query = query.trim();
    return (await jishoHelper.kanjiSearch(query, 1)).numKanji;
  }

  Future<int> numWords(String query) async {
    return (await jisho.searchForPhrase(query)).data.length;
  }

  Future<List<String>> searchKanjiSymbols(
    String query, {
    int limit = 100,
    int startIndex = 0,
    KanjiSearchOptions options = const KanjiSearchOptions(),
  }) async {
    assert(query != null);
    query += options._queryString;
    query = query.trim();

    int kanjiPerPage = jishoHelper.KanjiPage.KANJI_PER_PAGE;
    int startPage = (startIndex / kanjiPerPage).floor();
    int endPage = ((startIndex + limit) / kanjiPerPage).ceil();

    List<Future<KanjiPage>> pageFutures = [];
    for (int pageIndex = startPage; pageIndex < endPage; pageIndex++) {
      pageFutures.add(jishoHelper.kanjiSearch(query, pageIndex + 1));
    }

    List<KanjiPage> pages = await Future.wait(pageFutures);
    int firstPageStart = startIndex % kanjiPerPage;
    List<String> symbols = pages[0].kanji.sublist(
        firstPageStart, min(pages[0].kanji.length, firstPageStart + limit));

    for (int i = 1; i < pages.length; i++) {
      symbols.addAll(pages[i]
          .kanji
          .sublist(0, min(pages[i].kanji.length, limit - symbols.length)));
    }

    return symbols;
  }

  Future<List<KanjiModel>> searchKanji(
    String query, {
    int limit,
    int startIndex,
    KanjiSearchOptions options = const KanjiSearchOptions(),
  }) async {
    assert(query != null);
    List<String> symbols = await searchKanjiSymbols(
      query,
      limit: limit,
      startIndex: startIndex,
      options: options,
    );
    List<Future<KanjiModel>> modelFutures =
        symbols.map((s) => getKanji(s)).toList();

    return await Future.wait(modelFutures);
  }

  Future<KanjiModel> getKanji(
    String kanji, {
    KanjiSearchOptions options = const KanjiSearchOptions(),
  }) async {
    assert(kanji != null);
    kanji += options._queryString;
    kanji = kanji.trim();
    jisho.KanjiResult kanjiData = await jisho.searchForKanji(kanji);
    if (!kanjiData.found) throw KanjiNotFoundError(kanji);
    List<WordModel> examples = [];
    List<jisho.YomiExample> exampleData = kanjiData.kunyomiExamples;
    exampleData.addAll(kanjiData.onyomiExamples);
    for (jisho.YomiExample example in kanjiData.kunyomiExamples) {
      examples.add(WordModel(forms: [
        WordFormModel(
          word: example.example,
          reading: example.reading,
        )
      ], senses: [
        WordSenseModel(definitions: [example.meaning])
      ]));
    }

    return KanjiModel(
      character: kanji,
      jlpt: kanjiData.jlptLevel != null
          ? int.parse(kanjiData.jlptLevel.substring(1))
          : null,
      radicalForms: kanjiData.radical.forms,
      meaning: kanjiData.meaning.split(", "),
      frequency: kanjiData.newspaperFrequencyRank,
      kunyomi: kanjiData.kunyomi,
      onyomi: kanjiData.onyomi,
      examples: examples,
      radical: kanjiData.radical.symbol,
      parts: kanjiData.parts,
      strokeOrderGifUrl: kanjiData.strokeOrderGifUri,
    );
  }

  Future<String> randomKanjiSymbol({int maxJlpt}) async {
    var options = KanjiSearchOptions(joyo: true, jlpt: maxJlpt);
    int length = await numKanji("", options: options);
    var index = Random().nextInt(length);
    List<String> list = await searchKanjiSymbols(
      "",
      options: options,
      limit: 1,
      startIndex: index,
    );
    if (list.length == 0) throw KanjiNotFoundError("[random]");
    return list[0];
  }

  Future<List<WordModel>> searchWords(
    String query, {
    int limit,
    int startIndex,
    KanjiSearchOptions options = const KanjiSearchOptions(),
  }) async {
    assert(query != null);
    query += options._queryString;
    query.replaceAll(new RegExp("^ +"), "");
    var wordData = (await jisho.searchForPhrase(query)).data;
    if (startIndex >= wordData.length) return [];
    wordData = wordData.sublist(
      startIndex,
      wordData.length > startIndex + limit && limit > 0
          ? startIndex + limit
          : null,
    );

    return wordData.map<WordModel>((word) {
      return WordModel(
        jlpt:
            word.jlpt.length > 0 ? int.parse(word.jlpt[0].substring(6)) : null,
        senses: word.senses.map<WordSenseModel>((sense) {
          return WordSenseModel(
            definitions: List<String>.from(sense.english_definitions),
            wordtypes: List<String>.from(sense.parts_of_speech),
            info: List<String>.from(sense.info),
            appliesTo: List<String>.from(sense.restrictions),
            url: sense.links.length > 0 ? sense.links[0].url : null,
          );
        }).toList(),
        forms: word.japanese.map<WordFormModel>((form) {
          return WordFormModel(
            word: form.word,
            reading: form.reading,
          );
        }).toList(),
      );
    }).toList();
  }

  Future<WordModel> getWord(String word, {KanjiSearchOptions options}) async =>
      (await searchWords(
        word,
        options: options,
      ))[0];
}
