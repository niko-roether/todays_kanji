import 'package:flutter/material.dart';

class LargeViewLayout extends StatelessWidget {
  final List<Widget> annotations;
  final Widget topLeft;
  final Widget focus;
  final Widget meaning;
  final List<Widget> cards;

  LargeViewLayout({
    @required this.focus,
    this.annotations,
    this.topLeft,
    this.meaning,
    this.cards,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.all(18),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            topLeft ?? Container(),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: annotations ?? [],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ),
            Center(
              child: Column(
                children: [
                  focus,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: meaning,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ];
    children.addAll(cards ?? []);
    return ListView(children: children);
  }
}
