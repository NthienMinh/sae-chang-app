import 'package:expandable/expandable.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/result/result_info.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'answer_cubit.dart';

class CollapsedCheckedResultItem extends StatelessWidget {
  final AnswerModel answerModel;
  final ExpandableController controller;
  final int index;
  final QuestionModel questionModel;
  final bool isOffline;
  final AnswerCubit cubit;
  const CollapsedCheckedResultItem(
      {super.key,
      required this.answerModel,
      required this.index,
      required this.controller,
      required this.soundQuestionCubit, required this.questionModel, required this.isOffline, required this.cubit});
  final SoundCubit soundQuestionCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom:  Resizable.padding(context, 15),
          left: Resizable.padding(context,20),
          right: Resizable.padding(context, 20)),
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
        controller: controller,
        answerModel: answerModel,
        q: questionModel,
        index: index,
        isOffline: isOffline,
        soundQuestionCubit: soundQuestionCubit,
        icon: 'ic_down', cubit: cubit
      ),
    );
  }
}

