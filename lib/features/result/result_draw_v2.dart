import 'dart:convert';

import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/dialogs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../practice/draw_v2/draw_v2_view.dart';

class ResultDrawV2 extends StatelessWidget {
  const ResultDrawV2({super.key, required this.q, required this.answerModel});

  final QuestionModel q;
  final AnswerModel answerModel;

  @override
  Widget build(BuildContext context) {
    var answer = q.answer;
    var isSkip = answerModel.answer.isEmpty;
    final ink = Ink();
    loadPoints(ink);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSkip) ...[
          Padding(
              padding:
                  EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${AppText.txtYourAnswer.text}: ${answerModel.answer.first}',
                      style: TextStyle(
                          fontSize: Resizable.font(context, 14),
                          fontWeight: FontWeight.w700,
                          color: darkRedColor)),
                  IconButton(
                      onPressed: () {
                        Dialogs.showDialogCustom(
                            context,
                            true,
                            SizedBox(
                                height: Resizable.height(context) * 0.4,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: Resizable.padding(
                                          context, 0)),
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          image: AssetImage(
                                            "assets/icons/ic_bg_draw.png",
                                          ),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: CustomPaint(
                                    painter: Signature(ink: ink),
                                    size: Size.infinite,
                                  ),
                                )));
                      },
                      tooltip: AppText.txtSeeResult.text,
                      color: primaryColor,
                      icon: const Icon(Icons.remove_red_eye)),
                ],
              )),
        ],
        if (isSkip)
          Padding(
              padding:
                  EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
              child: Text(AppText.txtIgnoreQuestion.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      color: darkRedColor,
                      fontWeight: FontWeight.w700))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: Resizable.font(context, 7)),
            child: Text('${AppText.txtAnswer.text}: $answer',
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w700,
                    color: Colors.black))),
      ],
    );
  }

  loadPoints(Ink ink) {
    var points = <StrokePoint>[];
    for (var item in answerModel.answerState) {
      points.clear();
      ink.strokes.add(Stroke());
      var k = jsonDecode(item);
      for (var i in k['points']) {
        points.add(StrokePoint(x: i['x'], y: i['y'], t: i['t']));
      }
      ink.strokes.last.points = points.toList();
    }
  }
}