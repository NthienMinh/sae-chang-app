

import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/replace_text.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/untils/split_text.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ResultMatchColumn extends StatelessWidget {
  const ResultMatchColumn(
      {super.key, required this.q, required this.answerModel});

  final QuestionModel q;
  final AnswerModel answerModel;

  @override
  Widget build(BuildContext context) {
    debugPrint('=>>>>>>>>>>>>q.questionType: ${q.questionType}');
    var list1 = <Map<String, dynamic>>[];
    var list2 = <Map<String, dynamic>>[];
    List<String> splitList = ReplaceText.replaceCharacterJapan(q.question)
        .replaceAll("-", "|")
        .split(";");
    for (var item in splitList) {
      var splitMap = SplitText().splitMatchColumn(item, '|');
      if(splitMap.length == 2) {
        list1.add({
          'text1': splitMap[0].trim(),
          'text2': splitMap[1].trim(),
        });
      }

    }
    debugPrint('+>>>>>list1: $list1');

    for (var item in answerModel.answer) {
      var splitMap = SplitText().splitMatchColumn(item, '|');
      if (splitMap.length == 2) {
        list2.add({
          'text1': splitMap[0].trim(),
          'text2': splitMap[1].trim(),
        });
      }
    }
    var isSkip = list2.isEmpty;

    var countRight = list2.where((e) {
      return list1.any((element) =>
      element["text1"] == e["text1"] &&
          element["text2"] == e["text2"]);
    }).length;
    return ListView(
      shrinkWrap: true,
      children: [
        if (isSkip) ...[
          Padding(
              padding:
              EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
              child: Text(AppText.txtIgnoreQuestion.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w700))),
          Padding(
              padding:
              EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
              child: Text(AppText.txtAnswer.text,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w700))),
          ...list1.map((e) {
            return ItemMatchResult(result: true, text1: e['text1'], text2: e['text2']);
          })
        ],
        if (!isSkip)
         ...[
           ...list2.map((e) {
             var res = list1.any((element) =>
             element["text1"] == e["text1"] &&
                 element["text2"] == e["text2"]);
             return ItemMatchResult(result: res, text1: e['text1'], text2: e['text2']);
           }),

           if(countRight != list2.length)
             ...[
               Padding(
                   padding:
                   EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
                   child: Text(AppText.txtAnswer.text,
                       style: TextStyle(
                           color: primaryColor,
                           fontSize: Resizable.font(context, 14),
                           fontWeight: FontWeight.w700))),
               ...list2.map((e) {
                 return ItemMatchResult(result: true, text1: e['text1'], text2: list1.where((element) => element['text1'] == e['text1']).first['text2']);
               })
             ]
         ]
      ],
    );
  }
}


class ItemMatchResult extends StatelessWidget {
  const ItemMatchResult({super.key,
    this.paddingRight = 40,
    required this.result, required this.text1, required this.text2});
  final bool result;
  final String text1;
  final String text2;
  final double paddingRight;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: Resizable.padding(context, 5),
          right: Resizable.padding(context, paddingRight)),
      padding: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          color: result ? darkGreenColor : darkRedColor,
          borderRadius: BorderRadius.circular(7)),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    child: SplitTextCustom(
                        text: text1,
                        phoneticSize: 10,
                        kanjiFW: FontWeight.w600,
                        kanjiColor: Colors.white,
                        phoneticColor:  Colors.white,
                        kanjiSize: 16)
                  )),
              Container(
                color: Colors.white,
                width: 2,
              ),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    child:SplitTextCustom(
                        text: text2,
                        phoneticSize: 10,
                        kanjiFW: FontWeight.w600,
                        kanjiColor: Colors.white,
                        phoneticColor:  Colors.white,
                        kanjiSize: 16)
                  )),
            ],
          ),
          const Positioned.fill(child: Align(
            alignment: Alignment.center,
            child: VerticalDivider(color: Colors.white , width: 1, thickness: 2,),
          ))
        ],
      ),
    );
  }
}
