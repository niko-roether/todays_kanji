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
    String numStr = (senseIndex + 1).toString();
    var definitionText = "";
    if (model.appliesTo != null && model.appliesTo.length > 0)
      definitionText += "【${model.appliesTo.join("、")}】";
    definitionText += model.definitions.join(", ");

    List<Widget> definition = [];
    if (model.url == null) {
      definition.add(Flexible(
        child: Text(
          definitionText,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ));
    } else {
      definition.add(Flexible(
        child: Weblink(
          text: definitionText,
          url: model.url,
        ),
      ));
    }
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

    return Row(
      children: [
        Flexible(
          child: Text(numStr),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          //FIXME make responsive
          width: MediaQuery.of(context).size.width - 100,
          child: Column(
            children: definition,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
