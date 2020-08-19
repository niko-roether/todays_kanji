import 'package:flutter/material.dart';
import 'package:todays_kanji/model/word_form_model.dart';
import 'package:todays_kanji/model/word_model.dart';
import 'package:todays_kanji/model/word_sense_model.dart';
import 'package:todays_kanji/util/general.dart';
import 'package:todays_kanji/view/word_form_view.dart';
import 'package:todays_kanji/view/word_sense_view.dart';
import 'package:todays_kanji/widgets/annotation.dart';

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
    final contextWidth = MediaQuery.of(context).size.width;

    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                  width: contextWidth * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: WordFormView(mainForm, heading: true)),
              Row(
                children: [
                  Builder(
                    builder: (context) =>
                        model.common ? Annotation("common") : Container(),
                  ),
                  Builder(
                    builder: (context) => model.jlpt > 0
                        ? JLPTAnnotation(model.jlpt)
                        : Container(),
                  ),
                ],
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          partition && senses.length > 0 ? Divider(height: 8) : Container(),
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 10,
              children: senses,
            ),
          ),
          partition && forms.length > 0 ? Divider(height: 8) : Container(),
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              children: forms,
              crossAxisAlignment: WrapCrossAlignment.center,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          "/word",
          arguments: "${mainForm.word} ${katakanaToHiragana(mainForm.reading)}",
        );
      },
    );
  }
}
