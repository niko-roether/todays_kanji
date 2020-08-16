import 'package:flutter/material.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/widgets/annotation.dart';
import 'package:todays_kanji/widgets/weblink.dart';

class WordFormView extends StatelessWidget {
  final bool heading;
  final WordFormModel model;
  WordFormView(this.model, {this.heading = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> content = [];
    if (model.word != null) {
      content.add(Text(
        model.word,
        style: this.heading ? theme.textTheme.headline6 : null,
      ));
      if (model.reading != null) {
        content.add(Text(
          "「${model.reading}」",
        ));
      }
    } else if (model.reading != null) {
      content.add(Text(model.reading));
    }

    return Wrap(
      children: content,
      crossAxisAlignment: WrapCrossAlignment.end,
    );
  }
}

class WordSenseView extends StatelessWidget {
  final int senseIndex;
  final WordSenseModel model;
  WordSenseView(this.model, this.senseIndex);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var numStr = "($senseIndex)";
    var definitionText = "";
    if (model.appliesTo != null && model.appliesTo.length > 0)
      definitionText += "【${model.appliesTo.join("、")}】";
    definitionText += model.definitions.join(", ");

    List<Widget> definition = model.url != null
        ? [
            Flexible(child: Weblink(text: definitionText, url: model.url)),
          ]
        : [Flexible(child: Text(definitionText))];
    if (model.wordtypes != null && model.wordtypes.length > 0) {
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
        width: MediaQuery.of(context).size.width * 0.8,
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

class WordView extends StatelessWidget {
  final WordModel model;
  final bool partition;
  WordView(this.model, {this.partition = true});

  @override
  Widget build(BuildContext context) {
    List<WordSenseView> senses = [];
    List<WordSenseModel> senseData = model.senses;
    for (int i = 0; i < senseData.length; i++) {
      senses.add(WordSenseView(senseData[i], i));
    }

    List<Widget> forms = [];
    List<WordFormModel> formData = model.forms.sublist(1);
    if (0 < formData.length) {
      forms.add(Text("Also:"));
      forms.add(Container(width: 10));
    }
    for (WordFormModel form in formData) {
      forms.add(WordFormView(form));
      if (form != formData.last) forms.add(Text(" "));
    }

    final WordFormModel mainForm = model.forms[0];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: WordFormView(mainForm, heading: true)),
            Builder(
              builder: (context) =>
                  model.jlpt != null ? JLPTAnnotation(model.jlpt) : Container(),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        partition && senses.length > 0 ? Divider() : Container(),
        Padding(
          padding: EdgeInsets.all(8),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 10,
            children: senses,
          ),
        ),
        partition && forms.length > 0 ? Divider() : Container(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            children: forms,
            crossAxisAlignment: WrapCrossAlignment.center,
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
