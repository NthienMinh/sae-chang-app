import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_state.dart';
import 'package:sae_chang/features/bloc/voice_record_cubit.dart';
import 'package:sae_chang/features/practice/record/normal_record/voice_record_view.dart';
import 'package:sae_chang/features/practice/record/role_play/role_play_view.dart';
import 'package:sae_chang/features/practice/take_image/image_question_view.dart';
import 'package:sae_chang/features/practice/time_practice_cubit.dart';
import 'package:sae_chang/untils/btvn_utils.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/drawings.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:record/record.dart';
import 'package:screenshot/screenshot.dart';

import 'arrange/arrange_view.dart';
import 'count_down_clock.dart';
import 'drag_bottom_practice.dart';
import 'draw/draw_view.dart';
import 'draw_v2/draw_v2_view.dart';
import 'input_text/input_text_view.dart';
import 'instruction_title.dart';
import 'match_column/match_column_view.dart';
import 'multiple_choice/multiple_choice_view.dart';
import 'multiple_choice/multiple_image_view.dart';

class QuestionsView extends StatefulWidget {
  final QuestionState state;
  final PracticeBloc bloc;
  final Function() onSubmit;
  final Function() onAutoSubmit;
  final String type;
  final TimePracticeCubit timeCubit;
  final bool isOffline;
  final int duration;
  final int id, resultId;
  final AudioRecorder audioRecorder;
  QuestionsView(
      {super.key,
      required this.bloc,
      required this.onSubmit,
      required this.onAutoSubmit,
      required this.state,
      required this.type,
      required this.screenshotController,
      required this.timeCubit,
      required this.isOffline,
      required this.duration,
      required this.id,
      required this.resultId,
      required this.audioRecorder,
      required this.ctx})
      : voiceRecordCubit =
            VoiceRecordCubit(record: audioRecorder, context: ctx);
  final VoiceRecordCubit voiceRecordCubit;
  final ScreenshotController screenshotController;
  final BuildContext ctx;
  @override
  State<QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView>
    with LifecycleAware, LifecycleMixin {
  var drawController = DrawingsController(strokeWidth: 5);

  @override
  void didChangeDependencies() {
    if (Resizable.isTablet(context)) {
      drawController = DrawingsController(strokeWidth: 10);
    }
    super.didChangeDependencies();
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if (event == LifecycleEvent.push ||
        event == LifecycleEvent.visible ||
        event == LifecycleEvent.active) {
      widget.timeCubit.startTimer();
    } else {
      debugPrint(
          '=>>>>>>>>>>>>>>>>timeold: ${await widget.timeCubit.timeSaved()}');
      debugPrint('=>>>>>>>>>>>>>>>>timeCount: ${widget.timeCubit.time}');
      await widget.timeCubit.stopTimer(widget.state.question.id);
      debugPrint(
          '=>>>>>>>>>>>>>>>>timeSaved: ${await widget.timeCubit.timeSaved()}');
    }
  }

  @override
  void dispose() {
    widget.bloc.stopTimer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('=>>>>>>>>>typeQ: ${widget.state.question.questionType}');
    final btvnUtils = BtvnUtils(
        state: widget.state,
        bloc: widget.bloc,
        onSubmit: widget.onSubmit,
        screenshotController: widget.screenshotController,
        type: widget.type,
        isStudent: widget.bloc.role == 'student',
        drawController: drawController,
        audioRecorder: widget.audioRecorder,
        isOffline: widget.isOffline);
    return Stack(
      children: [
        SafeArea(
          child: Column(children: [
            if (widget.duration > 0)
              CountDownClock(
                duration: widget.duration,
                testId: widget.id,
                onAutoSubmit: widget.onAutoSubmit,
              ),
            InstructionTitle(state: widget.state),
            Flexible(
                child: widget.state.question.questionType == 1 ||
                        widget.state.question.questionType == 5
                    ? MultipleChoiceView(
                        questionModel: widget.state.question,
                        bloc: widget.bloc,
                        type: widget.type,
                        btvnUtils: btvnUtils)
                    : widget.state.question.questionType == 2
                        ? ImageQuestionView(
                            questionModel: widget.state.question,
                            bloc: widget.bloc,
                            type: widget.type,
                          )
                        : widget.state.question.questionType == 3
                            ? VoiceRecordView(
                                questionModel: widget.state.question,
                                bloc: widget.bloc,
                                voiceRecordCubit: widget.voiceRecordCubit,
                                type: widget.type,
                              )
                            : widget.state.question.questionType == 4
                                ? DrawView(
                                    key: Key("${widget.state.question.id}"),
                                    questionModel: widget.state.question,
                                    path: widget
                                            .state.question.answered.isNotEmpty
                                        ? widget.state.question.answered.first
                                        : "",
                                    bloc: widget.bloc,
                                    drawController: drawController,
                                    screenshotController:
                                        widget.screenshotController,
                                  )
                                : widget.state.question.questionType == 6
                                    ? LayoutBuilder(builder: (context, c) {
                                        return SingleChildScrollView(
                                          child: InputTextView(
                                            questionModel:
                                                widget.state.question,
                                            bloc: widget.bloc,
                                            type: widget.type,
                                            height: c.maxHeight,
                                          ),
                                        );
                                      })
                                    : widget.state.question.questionType == 7
                                        ? ArrangeView(
                                            questionModel:
                                                widget.state.question,
                                            bloc: widget.bloc,
                                            type: widget.type,
                                            btvnUtils: btvnUtils)
                                        : widget.state.question.questionType ==
                                                8
                                            ? MatchColumnView(
                                                questionModel:
                                                    widget.state.question,
                                                bloc: widget.bloc,
                                                type: widget.type,
                                                btvnUtils: btvnUtils,
                                              )
                                            : widget.state.question
                                                        .questionType ==
                                                    10
                                                ? RolePlayView(
                                                    questionModel:
                                                        widget.state.question,
                                                    bloc: widget.bloc,
                                                    voiceRecordCubit:
                                                        widget.voiceRecordCubit,
                                                    type: widget.type,
                                                  )
                                                // : widget.state.question
                                                //             .questionType ==
                                                //         22
                                                //     ? SpeakingView(
                                                //         questionModel: widget
                                                //             .state.question,
                                                //         bloc: widget.bloc,
                                                //         type: widget.type,
                                                //         btvnUtils: btvnUtils,
                                                //       )
                                                    : widget.state.question
                                                                .questionType ==
                                                            44
                                                        ? DrawV2View(
                                                            questionModel:
                                                                widget.state
                                                                    .question,
                                                            bloc: widget.bloc,
                                                          )
                                                        : MultipleImageView(
                                                            questionModel:
                                                                widget.state
                                                                    .question,
                                                            bloc: widget.bloc,
                                                            type: widget.type,
                                                          )),
            SizedBox(
              height: Resizable.height(context) * 0.1,
            )
          ]),
        ),
        DragBottomPractice(
          state: widget.state,
          bloc: widget.bloc,
          onSubmit: widget.onSubmit,
          screenshotController: widget.screenshotController,
          type: widget.type,
          isOffline: widget.isOffline,
          drawController: drawController,
          audioRecorder: widget.audioRecorder,
          isStudent: widget.bloc.role == 'student',
          id: widget.id,
          resultId: widget.resultId,
          dataId: widget.bloc.dataId,
          classId: widget.bloc.classId,
          userId: widget.bloc.userId,
        )
      ],
    );
  }
}

class DrawChangeCubit extends Cubit<bool> {
  DrawChangeCubit() : super(false);
}
