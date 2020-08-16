import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        direction: Axis.vertical,
        spacing: 10.0,
        children: [
          CircularProgressIndicator(),
          Text("Loading..."),
        ],
      ),
    );
  }
}
