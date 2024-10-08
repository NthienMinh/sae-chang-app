
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/replace_text.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ResultArrangeSentence extends StatelessWidget {
  const ResultArrangeSentence(
      {super.key, required this.q, required this.answerModel});

  final QuestionModel q;
  final AnswerModel answerModel;

  @override
  Widget build(BuildContext context) {;
    var ques = ReplaceText.replaceCharacterJapan(q.question).split("/")..removeWhere((element) => element.isEmpty);

    print('oooo${ques.length}');
    var listAns = answerModel.answer.map((e) => e.toString()).toList();
    var isSkip = !listAns.any((element) => element.isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isSkip)
          Padding(
              padding:
              EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
              child: Text(AppText.txtIgnoreQuestion.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w700))),
        if(!isSkip)
        Wrap(
          direction: Axis.horizontal,
         alignment: WrapAlignment.start,
         children: [
           ...ques.asMap().entries.map((e) {

             var index  = e.key;


             bool res = index < ques.length && ques[index].trim() == listAns[index].trim();
             bool notAns = index > listAns.length || listAns[index].isEmpty;
             return Container(
               height: Resizable.size(context, 50),
               width: notAns ? Resizable.size(context, 80) : null,
               padding: EdgeInsets.symmetric(
                 vertical: Resizable.padding(context, 5),
                 horizontal:  Resizable.padding(context, 10),
               ),
               margin: EdgeInsets.only(
                 right:  Resizable.padding(context, 5),
                 bottom:  Resizable.padding(context, 5),

               ),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(1000),
                   color: notAns ? Colors.grey.shade300 : res ? darkGreenColor : darkRedColor),
               child:  Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   SplitTextCustom(
                       text: notAns ? '' : listAns[index],
                       phoneticSize: 10,
                       kanjiFW: FontWeight.w600,
                       kanjiColor: Colors.white,
                       phoneticColor: Colors.white,
                       kanjiSize: 16)
                 ],
               )
             );
           }).toList()
         ],
       ),
        ...[
          Padding(
              padding:
              EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
              child: Text(AppText.txtAnswer.text,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w700))),
          Padding(
              padding:
              EdgeInsets.only(bottom: Resizable.font(context, 7) , right:Resizable.font(context, 30) ),
              child: SplitTextCustom(
                text: q.convertQuestion,
                isParagraph: true,
                kanjiSize: 16,
                phoneticSize: 8,

              )),
        ]
      ],
    );
  }
}


