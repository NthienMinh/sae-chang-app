import 'package:expandable/expandable.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'answer_cubit.dart';
import 'checked_item_collapsed.dart';
import 'checked_item_expanded.dart';

class ResultItem extends StatelessWidget {
  final AnswerModel answerModel;
  final QuestionModel questionModel;
  final int index;
  final ExpandableController _controller;
  final SoundCubit soundQuestionCubit;
  final bool isOffline;
  final AnswerCubit cubit;
  ResultItem(
      {super.key,
      required this.answerModel,
      required this.index,
      required this.soundQuestionCubit,
      required this.questionModel,
      required this.isOffline,
      required this.cubit})
      : _controller = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: _controller,
      theme: ExpandableThemeData(
        iconSize: Resizable.size(context, 20),
        iconColor: primaryColor,
      ),
      collapsed: CollapsedCheckedResultItem(
        answerModel: answerModel,
        index: index,
        controller: _controller,
        soundQuestionCubit: soundQuestionCubit,
        questionModel: questionModel,
        isOffline: isOffline,
        cubit: cubit,
      ),
      expanded: ExpandedCheckedResultItem(
        isOffline: isOffline,
        answerModel: answerModel,
        index: index,
        controller: _controller,
        soundQuestionCubit: soundQuestionCubit,
        questionModel: questionModel,
        cubit: cubit,
      ),
    );
  }
}
