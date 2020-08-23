class KanjiNotFoundError implements Exception {
  final String kanji;
  KanjiNotFoundError(this.kanji);

  @override
  String toString() {
    return "Could not find Kanji \"$kanji\"";
  }
}

class WordNotFoundError implements Exception {
  final String word;
  WordNotFoundError(this.word);

  @override
  String toString() {
    return "Could not find Word \"$word\"";
  }
}

class InvalidModelFieldTypeGetError implements Exception {
  final String field;
  final Type falseType;
  final Type trueType;

  InvalidModelFieldTypeGetError(this.field, this.falseType, this.trueType);

  @override
  String toString() {
    return "Could not convert model field \"$field\" of type $falseType to type $trueType";
  }
}

class InvalidModelFieldError implements Exception {
  final String field;

  InvalidModelFieldError(this.field);

  @override
  String toString() {
    return "The field \"$field\" does not exist in this Model";
  }
}

class InvalidModelFieldTypeError implements Exception {
  final String field;
  final Type type;

  InvalidModelFieldTypeError(this.field, this.type);

  @override
  String toString() {
    return "Could not convert model field \"$field\" of type $type to a valid type";
  }
}

class InvalidAPIResponseError {
  final String response;

  InvalidAPIResponseError(this.response);

  @override
  String toString() {
    String res = response;
    if (res.length > 100) {
      res = res.substring(0, 100) + "...";
    }
    return "Invalid API response:\n\n$res";
  }
}

class InvalidAPIRequest {
  final String msg;

  InvalidAPIRequest(this.msg);

  @override
  String toString() {
    return msg;
  }
}
