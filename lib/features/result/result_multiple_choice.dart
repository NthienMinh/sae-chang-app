import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ResultMultipleChoice extends StatelessWidget {
  const ResultMultipleChoice(
      {super.key, required this.q, required this.answerModel});

  final QuestionModel q;
  final AnswerModel answerModel;

  @override
  Widget build(BuildContext context) {
    bool isWaiting = answerModel.score == -1;
    var answer = CustomCheck.getAnswer(q);
    var listAnswer =  answerModel.answerState.isEmpty
            ? List.of(q.listAnswer)
            : answerModel.answerState.map((e) => e.toString()).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...listAnswer.map((e) {
          var list = ['A', 'B', 'C', 'D'];
          var index = listAnswer.indexOf(e);
          return Padding(
            padding: EdgeInsets.only(bottom: Resizable.padding(context, 7)),
            child: Row(
              children: [
                Container(
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
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    // child: Text(e.trim(),
                    //     style: TextStyle(
                    //         color: isWaiting
                    //             ? Colors.black
                    //             : answer == e
                    //                 ? darkGreenColor
                    //                 : answerModel.convertAnswer.first == e
                    //                     ? darkRedColor
                    //                     : Colors.black,
                    //         fontSize: Resizable.font(context, 15),
                    //         fontWeight: FontWeight.w800)),
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: SplitTextCustom(
                    text: e.trim(),
                    kanjiSize: 17,
                    phoneticSize: 10,
                    isParagraph: true,
                    phoneticColor: Colors.black,
                    kanjiColor: isWaiting
                        ? Colors.black
                        : answer == e
                            ? darkGreenColor
                            : answerModel.convertAnswer.first == e
                                ? darkRedColor
                                : Colors.black,
                    kanjiFW: FontWeight.w800,
                  ),
                ))
              ],
            ),
          );
        }),
        if (answerModel.convertAnswer.first == 'Bạn đã bỏ qua câu này!')
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
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
