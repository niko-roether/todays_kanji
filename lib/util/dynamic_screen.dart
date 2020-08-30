import 'package:flutter/material.dart';
import 'package:todays_kanji/util/general.dart';

mixin DynamicScreen<T> {
  T getArguments(BuildContext context) {
    T args = cast<T>(ModalRoute.of(context).settings.arguments);
    if (args == null) {
      showError(
        context,
        "The supplied arguments were null or of invalid type",
        onClose: () => Navigator.pop(context),
      );
    }
    return args;
  }
}
