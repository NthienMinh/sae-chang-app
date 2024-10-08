import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class ResultInputText extends StatelessWidget {
  const ResultInputText({super.key, required this.q, required this.answerModel});

  final QuestionModel q;
  final AnswerModel answerModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(answerModel.convertAnswer.first != 'Bạn đã bỏ qua câu này!')
        Container(
          constraints: const BoxConstraints(
            minHeight: 70,
          ),
            width: Resizable.width(context) * 0.7,
            padding: EdgeInsets.all(Resizable.font(context, 7)),
            margin: EdgeInsets.symmetric(
                vertical: Resizable.font(context, 7)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryColor,width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0.0, 3.0),
                  blurRadius: 4.0,
                )
              ],
            ),
            child: Text(answerModel.convertAnswer.first,
                style: TextStyle(
                    fontSize: Resizable.font(context, 15),
                    fontWeight: FontWeight.w700))),
        if(answerModel.convertAnswer.first == 'Bạn đã bỏ qua câu này!')
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Bạn đã bỏ qua câu này!',
              style: TextStyle(
                  fontSize: Resizable.font(context, 14),
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}
