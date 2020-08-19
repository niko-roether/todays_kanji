import 'package:flutter/material.dart';
import 'package:todays_kanji/model/word_sense_model.dart';
import 'package:todays_kanji/widgets/weblink.dart';

class WordSenseView extends StatelessWidget {
  final int senseIndex;
  final WordSenseModel model;
  WordSenseView(this.model, this.senseIndex);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contextWidth = MediaQuery.of(context).size.width;
    var numStr = "($senseIndex)";
    var definitionText = "";
    if (model.appliesTo != null && model.appliesTo.length > 0)
      definitionText += "【${model.appliesTo.join("、")}】";
    definitionText += model.definitions.join(", ");

    List<Widget> definition = model.url != null
        ? [Flexible(child: Weblink(text: definitionText, url: model.url))]
        : [
            Flexible(
                child: Text(
              definitionText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ))
          ];
    if (model.wordtypes.length > 0) {
      definition.add(
        Flexible(
          child: Text(
            model.wordtypes.join(", "),
            style: theme.textTheme.caption,
          ),
        ),
      );
    }
    if (senseIndex < 20)
      numStr = String.fromCharCode("①".codeUnitAt(0) + senseIndex);

    List<Widget> content = [
      Text(numStr),
      SizedBox(width: 10),
      Container(
        width: contextWidth * 0.6,
        child: Column(
          children: definition,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    ];
    return Row(
      children: content,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
