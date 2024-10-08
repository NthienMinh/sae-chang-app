

import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ResultSpeaking extends StatelessWidget {
  const ResultSpeaking({super.key, required this.q, required this.answerModel});
  final QuestionModel q;
  final AnswerModel answerModel;

  @override
  Widget build(BuildContext context) {

    var isSkip = answerModel.answer.isEmpty;
    var answer ='';
    if(answerModel.answer.isNotEmpty) {
      answer = answerModel.answer.first as String ;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isSkip)
          Padding(
              padding:
              EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
              child: Text(AppText.txtIgnoreQuestion.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      color: darkRedColor,
                      fontWeight: FontWeight.w700))),
       if(!isSkip) ...[
         Padding(
             padding: EdgeInsets.symmetric(
                 vertical: Resizable.font(context, 7)),
             child: Text(AppText.txtYourAnswer.text,
                 style: TextStyle(
                     fontSize: Resizable.font(context, 14),
                     fontWeight: FontWeight.w700,
                     color: darkRedColor))),
         Padding(
             padding:
             EdgeInsets.only(bottom: Resizable.padding(context, 7)),
             child: SplitTextCustom(
                 text: answer.trim(),
                 phoneticSize: Resizable.font(context, 9),
                 kanjiFW: FontWeight.w600,
                 kanjiColor: greenColor,
                 isParagraph: true,
               kanjiSize: 20,
                )),
       ]
      ],
    );
  }
}
