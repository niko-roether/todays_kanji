import 'package:flutter/material.dart';
import 'package:todays_kanji/widgets/conditional.dart';

typedef DataGetter<T> = T Function(BuildContext context);
typedef DataBuilder<T> = Widget Function(BuildContext context, T data);
typedef DataChecker<T> = bool Function(T data);

class DataConditional<T> extends StatelessWidget {
  final DataGetter<T> dataGetter;
  final DataBuilder<T> builder;
  final DataChecker<T> condition;

  DataConditional({this.dataGetter, this.condition, this.builder});

  @override
  Widget build(BuildContext context) {
    T data = dataGetter(context);
    return Conditional(
      condition: condition(data),
      child: Builder(builder: (BuildContext context) => builder(context, data)),
    );
  }

  factory DataConditional.notNull({
    DataGetter<T> dataGetter,
    DataBuilder<T> builder,
  }) {
    return DataConditional<T>(
      dataGetter: dataGetter,
      builder: builder,
      condition: (data) => data != null,
    );
  }
}
