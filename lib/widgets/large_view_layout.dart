import 'package:flutter/material.dart';

class LargeViewLayout extends StatelessWidget {
  final List<Widget> stackItems;
  final Alignment stackAlign;
  final Widget focus;
  final Widget subfocus;
  final List<Widget> cards;

  LargeViewLayout({
    @required this.focus,
    this.stackItems = const [],
    this.stackAlign = Alignment.topLeft,
    this.subfocus,
    this.cards,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [
      Center(
        child: Column(
          children: [
            focus,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: subfocus,
            )
          ],
        ),
      )
    ];
    stackChildren.addAll(stackItems);
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.all(18),
        child: Stack(
            alignment: stackAlign ?? Alignment.topLeft,
            children: stackChildren),
      ),
    ];
    children.addAll(cards ?? []);
    return ListView(children: children);
  }
}
