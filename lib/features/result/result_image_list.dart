import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class ResultImageList extends StatelessWidget {
  const ResultImageList({super.key, required this.q, required this.answerModel, required this.isOffline, required this.dir});

  final QuestionModel q;
  final AnswerModel answerModel;
  final bool isOffline;
  final String dir;

  @override
  Widget build(BuildContext context) {
    debugPrint('=>>>>>${answerModel.answer}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(answerModel.answer.isNotEmpty)
        SizedBox(
            height: Resizable.size(context, 150),
            child: ListView.builder(
                itemCount: answerModel.answer.length,
                scrollDirection: Axis.horizontal,
                padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(Routes.fullScreen, arguments: {
                      'imageList': answerModel.answer.map((e) => e.toString()).toList(),
                      'init': i,
                      'type': isOffline? "download"  : "network",
                      'dir':dir
                    });
                  },
                  child: Container(
                    width: Resizable.size(context, 150),
                    margin:
                    EdgeInsets.only(right: Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                        image: isOffline ?  DecorationImage(
                           fit: BoxFit.fill,
                          image: FileImage(File(answerModel.answer[i].toString()))
                        ) : DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(answerModel.answer[i].toString())
                    ),
                        borderRadius:
                        BorderRadius.circular(Resizable.size(context, 20))),

                  ),
                ))),
        if(answerModel.convertAnswer.isEmpty)
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.font(context, 7)),
              child: Text(AppText.txtIgnoreQuestion.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w700))),
      ],
    );
  }
}
