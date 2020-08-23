import 'dart:math';

import 'package:todays_kanji/model/kanji_model.dart';
import 'package:todays_kanji/model/word_form_model.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/model/word_sense_model.dart';
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
    return (await jishoHelper.kanjiSymbolSearch(query)).numResults;
  }

  Future<List<String>> searchKanjiSymbols(
    String query, {
    int page = 0,
    KanjiSearchOptions options,
  }) async {
    assert(query != null);
    assert(page != null);

    query += options._queryString;
    query = query.trim();

    return (await jishoHelper.kanjiSymbolSearch(query, page: page)).results;
  }

  Future<List<KanjiModel>> searchKanji(
    String query, {
    int page,
    KanjiSearchOptions options = const KanjiSearchOptions(),
  }) async {
    assert(query != null);
    List<String> symbols = await searchKanjiSymbols(
      query,
      page: page,
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
          : 0,
      radicalForms: kanjiData.radical.forms,
      meaning: kanjiData.meaning.split(", "),
      frequency: kanjiData.newspaperFrequencyRank ?? 0,
      kunyomi: kanjiData.kunyomi ?? [],
      onyomi: kanjiData.onyomi ?? [],
      examples: examples ?? [],
      radical: kanjiData.radical.symbol,
      parts: kanjiData.parts,
      strokeOrderGifUrl: kanjiData.strokeOrderGifUri,
    );
  }

  Future<String> randomKanjiSymbol({int maxJlpt}) async {
    var options = KanjiSearchOptions(joyo: true, jlpt: maxJlpt);
    int length = await numKanji("", options: options);
    var index = Random().nextInt(length);

    int kanjiPerPage = jishoHelper.RESULTS_PER_PAGE;
    int pageNum = (index / kanjiPerPage).floor();
    int pageIndex = index % kanjiPerPage;

    List<String> list = await searchKanjiSymbols(
      "",
      options: options,
      page: pageNum,
    );
    if (list.length == 0) throw KanjiNotFoundError("[random]");
    return list[pageIndex];
  }

  Future<List<WordModel>> searchWords(
    String query, {
    int page = 0,
    KanjiSearchOptions options = const KanjiSearchOptions(),
  }) async {
    assert(query != null);
    query += (options?._queryString ?? "");
    query = query.trim();
    var wordData = (await jishoHelper.wordSearch(query, page: page)).results;

    return wordData.map<WordModel>((word) {
      return WordModel(
        jlpt: word.jlpt.length > 0 ? int.parse(word.jlpt[0].substring(6)) : 0,
        common: word.is_common,
        senses: word.senses.map<WordSenseModel>((sense) {
          return WordSenseModel(
            definitions: List<String>.from(sense.english_definitions) ?? [],
            wordtypes: List<String>.from(sense.parts_of_speech) ?? [],
            info: List<String>.from(sense.info) ?? [],
            appliesTo: List<String>.from(sense.restrictions) ?? [],
            url: sense.links.length > 0
                ? sense.links[0].url
                    .replaceFirst(RegExp("\\?oldid=[0-9]+\$"), "")
                : null,
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

  Future<WordModel> getWord(String word, {KanjiSearchOptions options}) async {
    return (await searchWords(word, options: options))[0];
  }
}
