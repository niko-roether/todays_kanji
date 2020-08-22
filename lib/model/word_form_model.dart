class WordFormModel {
  final String word;
  final String reading;
  final String readingRomaji;

  WordFormModel({
    this.word,
    this.reading,
    this.readingRomaji,
  }) : assert(word != null || reading != null);
}
