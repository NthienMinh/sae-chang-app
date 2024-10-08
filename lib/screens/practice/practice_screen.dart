import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_state.dart';
import 'package:sae_chang/features/practice/dialogs/ignore_confirm_dialog.dart';
import 'package:sae_chang/features/practice/dialogs/submit_confirm_dialog.dart';
import 'package:sae_chang/features/practice/dialogs/submit_error_dialog.dart';
import 'package:sae_chang/features/practice/dialogs/submit_succes_dialog.dart';
import 'package:sae_chang/features/practice/questions_view.dart';
import 'package:sae_chang/features/practice/time_practice_cubit.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/services/video_service.dart';
import 'package:sae_chang/untils/dialogs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/loading_progress.dart';
import 'package:screenshot/screenshot.dart';
import 'package:record/record.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen(
      {super.key,
      required this.id,
      required this.type,
      required this.resultId,
      required this.dataId,
      this.numOfQuestion = 0,
      required this.duration,
      required this.isOffline, required this.userId, required this.classId});

  final int id;
  final int resultId;
  final String type;
  final int numOfQuestion;
  final int duration;
  final bool isOffline;
  final int dataId;
  final int userId;
  final int classId;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final focusNode = FocusNode();
  final screenshotController = ScreenshotController();
  final audioRecorder = AudioRecorder();

  @override
  void dispose() {
    MediaService.instance.stop();
    if (VideoService.instance.player != null) {
      VideoService.instance.dispose();
    }
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      debugPrint('focus');
      FocusManager.instance.primaryFocus?.unfocus();
    }

    audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => TimePracticeCubit(widget.id,widget.resultId, widget.type),
        child: BlocBuilder<TimePracticeCubit, int>(
          builder: (context, state) {
            final timeCubit = context.read<TimePracticeCubit>();
            return Stack(
              children: [
                const FractionallySizedBox(
                  heightFactor: 0.4,
                  widthFactor: 1.0,
                  //for full screen set heightFactor: 1.0,widthFactor: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/ic_bg_flashcard.png",),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => PracticeBloc()
                    ..add(StartEvent(
                        widget.classId,
                        widget.userId,
                        widget.id,
                        widget.dataId,
                        widget.resultId,
                        widget.type,
                        context,
                        widget.isOffline,
                        widget.numOfQuestion)),
                  child: BlocConsumer<PracticeBloc, PracticeState>(
                    listener: (cc, state) {
                      if (state is SubmittingState) {
                        Navigator.of(context).pop();
                      }
                      if (state is SubmittedState) {
                        showDialog(
                          context: cc,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            context = context;
                            return SubmitSuccessDialog(btnReturn: () async {
                              // if (widget.level != null &&
                              //     widget.testId == 100 + widget.level!) {
                              //   Navigator.pop(context);
                              //   Navigator.pop(context, state.result);
                              //   Navigator.of(context, rootNavigator: true)
                              //       .pushNamed(Routes.generalityResult,
                              //       arguments: {
                              //         'lessonId':
                              //         state.result['answerDate'],
                              //         'testId': 100 + widget.level!,
                              //         'score': state.result['score'],
                              //         'level': widget.level!,
                              //       });
                              // } else {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context, state.result);
                                }
                              // }
                            });
                          },
                        );
                      }
                      if (state is SubmitError) {
                        showDialog(
                          context: cc,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            context = context;
                            return SubmitErrorDialog(
                                error: state.errorList.join('\n'),
                                btnReturn: () async {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                });
                          },
                        );
                      }
                    },
                    builder: (cc, state) {
                      final bloc = BlocProvider.of<PracticeBloc>(cc);
                      if (state is QuestionState) {
                        debugPrint('=>>>>>>>>> ID: ${state.question.id}');
                        return GestureDetector(
                          onTap: () {
                            if (state.question.questionType == 6) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            resizeToAvoidBottomInset: true,
                            appBar: AppBar(
                              backgroundColor: primaryColor,
                              elevation: 0,
                              iconTheme:
                                  const IconThemeData(color: Colors.white),
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              toolbarHeight: 20,
                            ),
                            body: QuestionsView(
                              state: state,
                              ctx: cc,
                              timeCubit: timeCubit,
                              audioRecorder: audioRecorder,
                              screenshotController: screenshotController,
                              isOffline: widget.isOffline,
                              duration: widget.duration,
                              id: widget.id,
                              onAutoSubmit: () async {
                                await timeCubit.stopTimer(state.question.id);
                                timeCubit.isConfirmSubmit = true;
                                if (context.mounted) {
                                  Dialogs.showDialogCustom(
                                      context,
                                      false,
                                      PopScope(
                                        canPop: false,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: Resizable.padding(
                                                  context, 20),
                                            ),
                                            Icon(
                                              Icons.lock_clock,
                                              color: primaryColor,
                                              size: Resizable.size(context, 90),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            Resizable.size(
                                                                context, 30),
                                                        vertical:
                                                            Resizable.size(
                                                                context, 20))
                                                    .copyWith(bottom: 0),
                                                child: Text(
                                                    AppText.txtTimeOver.text,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize:
                                                            Resizable.font(
                                                                context, 22),
                                                        color: primaryColor),
                                                    textAlign:
                                                        TextAlign.center)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Resizable.size(
                                                              context, 15),
                                                      vertical: Resizable.size(
                                                          context, 10))
                                                  .copyWith(bottom: 0),
                                              child: Text(
                                                  AppText
                                                      .txtSystemAutoSubmit.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Resizable.font(
                                                          context, 14),
                                                      color:
                                                          greyColor.shade600),
                                                  textAlign: TextAlign.center),
                                            ),
                                            SizedBox(
                                              height: Resizable.padding(
                                                  context, 20),
                                            ),
                                          ],
                                        ),
                                      ));
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (context.mounted) {
                                    bloc.add(SubmitEvent(
                                        context,
                                        widget.id,
                                        widget.resultId,
                                        widget.duration,
                                        widget.type));
                                  }
                                }
                              },
                              onSubmit: () async {
                                await timeCubit.stopTimer(state.question.id);
                                timeCubit.isConfirmSubmit = true;
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dc) {
                                      return state.listIgnore.isNotEmpty
                                          ? IgnoreConfirmDialog(
                                              subTitle:
                                                  '${state.listIgnore.length}/${state.count}',
                                              onDoAgain: () async {
                                                Navigator.pop(context);
                                                bloc.isJumpToIgnoreQuestion =
                                                    true;
                                                final index = state
                                                    .listQuestions
                                                    .indexWhere((element) =>
                                                        element.id ==
                                                        state.listIgnore.first
                                                            .id);
                                                bloc.add(JumpEvent(index));
                                              },
                                              btnYes: () async {
                                                var time =
                                                    await timeCubit.timeSaved();
                                                if (context.mounted) {
                                                  bloc.add(SubmitEvent(
                                                      context,
                                                      widget.id,
                                                      widget.resultId,
                                                      time,
                                                      widget.type));
                                                }
                                              },
                                              btnNo: () {
                                                timeCubit.isConfirmSubmit =
                                                    false;
                                                Navigator.of(context).pop();
                                                VideoService.instance.play();
                                                timeCubit.startTimer();
                                              },
                                            )
                                          : SubmitConfirmDialog(
                                              onDoAgain: () async {
                                                Navigator.pop(context);
                                                bloc.add(StartEvent(
                                                    widget.classId,
                                                    widget.userId,
                                                    widget.id,
                                                    widget.dataId,
                                                    widget.resultId,
                                                    widget.type,
                                                    context,
                                                    widget.isOffline,
                                                    widget.numOfQuestion,
                                                    isDoAgain: true));
                                              },
                                              btnYes: () async {
                                                var time =
                                                    await timeCubit.timeSaved();
                                                if (context.mounted) {
                                                  bloc.add(SubmitEvent(
                                                      context,
                                                      widget.id,
                                                      widget.resultId,
                                                      time,
                                                      widget.type));
                                                }
                                              },
                                              btnNo: () {
                                                timeCubit.isConfirmSubmit =
                                                    false;
                                                Navigator.of(context).pop();
                                                VideoService.instance.play();
                                                timeCubit.startTimer();
                                              },
                                            );
                                    },
                                  );
                                }
                              },
                              bloc: bloc,
                              type: widget.type, resultId: widget.resultId,
                            ),
                          ),
                        );
                      }

                      return const Center(child: LoadingProgress());
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

