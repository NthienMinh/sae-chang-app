import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class ResultImageMultipleChoice extends StatelessWidget {
  const ResultImageMultipleChoice(
      {super.key, required this.q, required this.answerModel, required this.dir});

  final QuestionModel q;
  final AnswerModel answerModel;
  final String dir;

  @override
  Widget build(BuildContext context) {
    var list = ['A', 'B', 'C', 'D'];
    bool isWaiting = answerModel.score == -1;
    var answer = CustomCheck.getAnswer(q);
    var listAnswer = answerModel.answerState.isEmpty
        ? List.of(q.listAnswer)
        : answerModel.answerState.map((e) => e.toString()).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // height: Resizable.height(context) * 0.28,
          width: double.infinity,
          child: GridView.builder(
            padding: EdgeInsets.only(
              right: Resizable.padding(context, 30),
              top: Resizable.padding(context, 10),
              bottom: Resizable.padding(context, 20),
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: Resizable.padding(context, 5),
              mainAxisSpacing: Resizable.padding(context, 5), // 2 items per row
            ),
            itemCount: listAnswer.length,
            itemBuilder: (BuildContext context, int index) {
              debugPrint(listAnswer[index]);
              var e = listAnswer[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(Routes.fullScreen, arguments: {
                    'imageList': listAnswer,
                    'init': listAnswer.indexOf(e),
                    'type': "download",
                    'dir':dir
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: primaryColor, width: 2),
                          image: DecorationImage(
                              image: FileImage(File(CustomCheck.getFlashCardImage(
                                  listAnswer[index], dir))))),
                    ),
                    Positioned(
                      top: 5,
                      left: 10,
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isWaiting
                                  ? answerModel.convertAnswer.first == e
                                      ? primaryColor
                                      : Colors.white
                                  : answer == e
                                      ? darkGreenColor
                                      : answerModel.convertAnswer.first == e
                                          ? darkRedColor
                                          : Colors.white,
                              border: Border.all(
                                  color: isWaiting
                                      ? primaryColor
                                      : answer == e ||
                                              answerModel.convertAnswer.first == e
                                          ? Colors.transparent
                                          : primaryColor,
                                  width: 1)),
                          child: Center(
                            child: Text(
                              list[index],
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 16),
                                  color: isWaiting
                                      ? answerModel.convertAnswer.first == e
                                          ? Colors.white
                                          : primaryColor
                                      : answer == e ||
                                              answerModel.convertAnswer.first == e
                                          ? Colors.white
                                          : primaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom:0,
                        right:0,
                        child:  Container(
                        height: Resizable.size(context, 20),
                        width: Resizable.size(context, 20),
                        decoration: BoxDecoration(
                          color: primaryColor.shade300,
                          borderRadius: BorderRadius.only(
                              topLeft:
                              Radius.circular(Resizable.size(context, 10)),
                              bottomRight:
                              Radius.circular(Resizable.size(context, 10))),
                        ),
                        child: Center(
                            child: Icon(
                              Icons.zoom_in_rounded,
                              size: Resizable.size(context, 15),
                              color: Colors.white,
                            ))))
                  ],
                ),
              );
            },
          ),
        ),
        if (answerModel.convertAnswer.first == 'Bạn đã bỏ qua câu này!')
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
