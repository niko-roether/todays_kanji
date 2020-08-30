import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todays_kanji/util/general.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget appBar;

  Screen({@required this.child, @required this.appBar});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: RubberBandScroll(),
      child: Scaffold(
        appBar: appBar,
        body: SizedBox.expand(child: child),
      ),
    );
  }
}
