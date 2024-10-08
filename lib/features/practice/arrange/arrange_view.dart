import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/shared_preferences.dart';
import 'package:sae_chang/untils/btvn_utils.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/replace_text.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_scroll_bar.dart';
import 'arrange_word_item.dart';

class ArrangeView extends StatelessWidget {
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final String type;
  final BtvnUtils btvnUtils;
  const ArrangeView(
      {super.key, required this.questionModel, required this.bloc, required this.type, required this.btvnUtils,});

  @override
  Widget build(BuildContext context) {
    List<String> resultList = questionModel.answered;
    if (questionModel.answered.isEmpty) {
      List<String> splitList = ReplaceText.replaceCharacterJapan(questionModel.question).split("/")..removeWhere((element) => element.isEmpty);
      for (int i = 0; i < splitList.length; i++) {
        resultList.add("");
      }
      questionModel.answered = resultList;
      splitList.shuffle();
      questionModel.answerState = splitList;
    }
    return Column(
      children: [
        Expanded(
          child: Card(
            margin: CustomPadding.questionCardPadding(context).copyWith(
              bottom: Resizable.padding(context, 20)
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
                side: const BorderSide(color: Color(0xffE0E0E0), width: 1)),
            child: Center(
              child: CustomScrollBar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10 ),
                  child: Column(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: 1,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: Resizable.size(context, 5),
                          runSpacing: Resizable.size(context, 10),
                          children: [
                            ...questionModel.answered.map((e) => e == ""
                                ?const EmptyItemArrange()
                                : GestureDetector(
                                    onTap: () {
                                      questionModel.answerState[
                                          questionModel.answerState.indexOf(
                                              questionModel.answerState.firstWhere(
                                                  (element) => element == ""))] = e;
                                      questionModel.answered[
                                          questionModel.answered.indexOf(e)] = "";
                                      bloc.add(UpdateEvent());
                                      BaseSharedPreferences.savePracticeData(
                                          questionModel, type, bloc.id, bloc.resultId);

                                      bloc.cancelTimer();
                                    },
                                    child:ArrangeWordItem(
                                       text: e,
                                      isChoose: true,
                                    ),
                                  ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 50,),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: 1,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: Resizable.size(context, 5),
                          runSpacing: Resizable.size(context, 10),
                          children: [
                            ...questionModel.answerState.map((e) => e == ""
                                ? const EmptyItemArrange()
                                : GestureDetector(
                                    onTap: () {
                                      questionModel.answered[questionModel.answered
                                          .indexOf(questionModel.answered.firstWhere(
                                              (element) => element == ""))] = e;
                                      questionModel.answerState[
                                          questionModel.answerState.indexOf(e)] = "";
                                      bloc.add(UpdateEvent());
                                      BaseSharedPreferences.savePracticeData(
                                          questionModel, type, bloc.id, bloc.resultId);


                                      if(questionModel.answerState.every((element) =>  element.isEmpty)) {
                                        bloc.autoSkip(() {

                                          btvnUtils.autoNext(context, questionModel.questionType, bloc.dataId, bloc.id, bloc.classId, bloc.userId, bloc.resultId);
                                        });
                                      }
                                    },
                                    child: ArrangeWordItem(
                                      text: e,
                                      isChoose: false,
                                    ),
                                  ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: Resizable.height(context) * 0.05,)
      ],
    );
  }
}
class EmptyItemArrange extends StatelessWidget {
  const EmptyItemArrange({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Resizable.size(context, 100),
        height: Resizable.size(context, 45),
        decoration: BoxDecoration(
          color: oldAnswer,
          borderRadius: BorderRadius.circular(
              Resizable.size(context, 1000)),
        ));
  }
}


class EmptyItemArrangeV1 extends StatelessWidget {
  const EmptyItemArrangeV1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Resizable.size(context, 60),
        height: Resizable.size(context, 60),
        decoration: BoxDecoration(
          color: oldAnswer,
          borderRadius: BorderRadius.circular(
              Resizable.size(context, 10)),
        ));
  }
}
