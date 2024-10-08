
import 'package:expandable/expandable.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/practice/paragraph_view.dart';
import 'package:sae_chang/features/practice/record/normal_record/sounder.dart';
import 'package:sae_chang/features/result/result_arrange_sentence.dart';
import 'package:sae_chang/features/result/result_draw_v2.dart';
import 'package:sae_chang/features/result/result_draw_view.dart';
import 'package:sae_chang/features/result/result_image_list.dart';
import 'package:sae_chang/features/result/result_image_mutiple_choice.dart';
import 'package:sae_chang/features/result/result_input_text.dart';
import 'package:sae_chang/features/result/result_match_column.dart';
import 'package:sae_chang/features/result/result_multiple_choice.dart';
import 'package:sae_chang/features/result/result_speaking.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

import 'answer_cubit.dart';
import 'icon_result.dart';
import 'image_question_res.dart';


class ResultInfoView extends StatelessWidget {
  const ResultInfoView(
      {super.key,
      required this.answerModel,
      required this.q,
      required this.index,
      this.widget,
      required this.soundQuestionCubit,
      required this.icon,
      required this.controller, required this.isOffline, required this.cubit});

  final AnswerModel answerModel;
  final String icon;
  final QuestionModel q;
  final int index;
  final Widget? widget;
  final SoundCubit soundQuestionCubit;
  final ExpandableController controller;
  final bool isOffline;
  final AnswerCubit cubit;
  bool checkExpanded(QuestionModel q,AnswerModel a ) {
    return q.refer.isNotEmpty || a.teacherNote.isNotEmpty || q.explain.isNotEmpty || a.records.isNotEmpty || a.images.isNotEmpty;
  }
  @override
  Widget build(BuildContext context) {
    var isExpand = checkExpanded(q, answerModel);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: IconResult(
                index: index,
                answerModel: answerModel,
              )
            ),
            if(isExpand)
            Transform.translate(
              offset:  Offset(
              Resizable.padding(context, 10), 0),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => controller.toggle.call(),
                  splashRadius: Resizable.size(context, 20),
                  iconSize: Resizable.size(context, 30),
                  color: primaryColor,
                  icon: icon != 'ic_down' ? const Icon(Icons.keyboard_arrow_up_rounded) : const Icon(Icons.keyboard_arrow_down_rounded)
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: Resizable.padding(context, 30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (q.instruction != "")
                Padding(
                    padding:
                        EdgeInsets.only(bottom: Resizable.padding(context, 7)),
                    child: SplitTextCustom(
                        text: q.instruction.trim(),
                        phoneticSize: Resizable.font(context, 9),
                        kanjiFW: FontWeight.w600,
                        kanjiColor: primaryColor,
                        isParagraph: true,
                        kanjiSize: Resizable.font(context, 15))),
              if (q.question != "" && ![7 , 8 , 10].contains(q.questionType) )
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 0),
                      vertical: Resizable.padding(context, 5)),
                  child: Builder(
                    builder: (context) {
                      var list = q.question.split('\n');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...list.map((e) {
                            return  SplitTextCustom(
                                text: e.trim(),
                                phoneticSize: Resizable.font(context, 12),
                            kanjiFW: FontWeight.w700,

                            isParagraph: true,
                            kanjiSize: Resizable.font(context, 20));
                      })
                        ],
                      );
                    }
                  ),
                ),
              if (q.sound != "")
                Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Resizable.size(context, 5),
                    ),
                    child: Sounder1(
                      CustomCheck.getAudioLink(q.listSound.first,cubit.dir ),
                      size: Resizable.size(context, 20),
                      elevation: 0,
                      iconColor: primaryColor,
                      soundCubit: soundQuestionCubit,
                      type: 1,
                      soundType: 'download',
                      q: q,
                    )),
              if (q.image != "")
               ImageQuestionRes(q: q, dir:cubit.dir ),
              if(q.paragraph.isNotEmpty)
                ParagraphView(questionModel: q , isResult: true),
              if (answerModel.questionType == 44)
                ResultDrawV2(q: q, answerModel: answerModel),
              if (answerModel.questionType == 22)
                ResultSpeaking(q: q, answerModel: answerModel),
              if (answerModel.questionType == 11)
                ResultImageMultipleChoice(q: q, answerModel: answerModel, dir: cubit.dir),
              if (answerModel.questionType == 1 ||
                  answerModel.questionType == 5)
                ResultMultipleChoice(q: q, answerModel: answerModel),
              if (![1,5,11,44, 22].contains(answerModel.questionType) )
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.font(context, 7)),
                    child: Text(AppText.txtYourAnswer.text,
                        style: TextStyle(
                            fontSize: Resizable.font(context, 14),
                            fontWeight: FontWeight.w700,
                            color: darkRedColor))),
              if (answerModel.questionType == 6)
                ResultInputText(q: q, answerModel: answerModel),
              if (answerModel.questionType == 8)
                ResultMatchColumn(q: q, answerModel: answerModel),
              if (answerModel.questionType == 7 )
                ResultArrangeSentence(q:q , answerModel: answerModel,),
              if(answerModel.questionType == 4 )
                ResultDrawView(q: q, answerModel: answerModel, isOffline: isOffline, dir: cubit.dir,),
              if(answerModel.questionType == 2 )
                ResultImageList(q: q, answerModel: answerModel, isOffline: isOffline, dir: cubit.dir,),
              if (answerModel.questionType == 3 ||
                  answerModel.questionType == 10)
                answerModel.convertAnswer.isNotEmpty
                    ? Column(
                        children: [
                          ...answerModel.answer.map((e) => Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Resizable.size(context, 5),
                                //right: Resizable.size(context, 30),
                              ),
                              child: Sounder1(
                                e.toString(),
                                size: Resizable.size(context, 20),
                                elevation: 0,
                                iconColor: primaryColor,
                                soundCubit: soundQuestionCubit,
                                type: 1,
                                soundType: isOffline ? 'download' : 'network',
                                q: q,
                              )))
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.font(context, 7)),
                        child: Text(AppText.txtIgnoreQuestion.text,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 14),
                                fontWeight: FontWeight.w800))),
            ],
          ),
        ),
        if (widget != null) widget!
      ],
    );
  }
}
