class WordFormModel {
  final String word;
  final String reading;

  WordFormModel({
    this.word,
    this.reading,
  }) : assert(word != null || reading != null);
}
