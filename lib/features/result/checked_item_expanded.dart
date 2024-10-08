import 'package:expandable/expandable.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/result/result_info.dart';
import 'package:sae_chang/features/result/teacher_note_result.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'answer_cubit.dart';
import 'explain_result.dart';



class ExpandedCheckedResultItem extends StatelessWidget {
  final AnswerModel answerModel;
  final int index;
  final ExpandableController controller;
  final QuestionModel questionModel;
  final SoundCubit soundQuestionCubit;
  final bool isOffline;
  final AnswerCubit cubit;
  const ExpandedCheckedResultItem(
      {super.key,
      required this.answerModel,
      required this.index,
      required this.controller,
      required this.soundQuestionCubit, required this.questionModel, required this.isOffline, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Resizable.padding(context, 20),
          right: Resizable.padding(context, 20),
          bottom: Resizable.padding(context, 15)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 15),
          vertical: Resizable.padding(context, 5)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(Resizable.padding(context, 15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0.0, 3.0),
            spreadRadius: 2,
            blurRadius: 4.0,
          ),
        ],
        border: Border.all(
            width: 1,
            color: primaryColor),
      ),
      child: ResultInfoView(
        isOffline: isOffline,
        answerModel: answerModel,
        q: questionModel,
        index: index,
        soundQuestionCubit: soundQuestionCubit,
        controller: controller,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(questionModel.explain.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/ic_explain.png', height: 25, width: 25,),
                      const SizedBox(width: 10,),
                      IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(
                              AppText.txtExplain.text,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Resizable.font(context, 15)),
                            ),
                            const Divider(
                              color: primaryColor,
                              height: 2,
                              thickness: 2,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ExplainResult(explain: questionModel.explain ),
            ],
            if(answerModel.teacherNote != '' || answerModel.images.isNotEmpty || answerModel.records.isNotEmpty)...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10).copyWith(top: 0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/ic_note_ss.png', height: 25,color: primaryColor),
                      const SizedBox(width: 10,),
                      IntrinsicWidth(
                        child: Column(

                          children: [
                            Text(
                              AppText.txtTeacherNote.text,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Resizable.font(context, 15)),
                            ),
                            const Divider(
                              color: primaryColor,
                              height: 2,
                              thickness: 2,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TeacherNoteResult(answerModel: answerModel, questionModel: questionModel, soundCubit: soundQuestionCubit, dir: cubit.dir,),
            ],
            if(questionModel.refer.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10).copyWith(top: 0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/ic_grammar_note.png', height: 25, width: 25,),
                      const SizedBox(width: 10,),
                      IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(
                              'THAM KHẢO',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Resizable.font(context, 15)),
                            ),
                            const Divider(
                              color: primaryColor,
                              height: 2,
                              thickness: 2,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(questionModel.refer)
            ]

          ],
        ),
        icon: 'ic_up', cubit: cubit,
      ),
    );
  }
}

