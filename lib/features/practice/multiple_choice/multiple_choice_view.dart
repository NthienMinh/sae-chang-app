import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/practice/multiple_choice/selector.dart';
import 'package:sae_chang/features/practice/paragraph_view.dart';
import 'package:sae_chang/features/practice/question_custom.dart';
import 'package:sae_chang/features/practice/record/normal_record/sounder.dart';
import 'package:sae_chang/features/practice/video_view.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/shared_preferences.dart';
import 'package:sae_chang/untils/btvn_utils.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_scroll_bar.dart';
import 'package:sae_chang/widgets/next_back_widget.dart';
import 'image_list.dart';

class MultipleChoiceView extends StatelessWidget {
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final String type;
  final BtvnUtils btvnUtils;

  const MultipleChoiceView(
      {super.key,
      required this.questionModel,
      required this.bloc,
      required this.type,
      required this.btvnUtils});

  @override
  Widget build(BuildContext context) {
    debugPrint('=>>>>>aaaaa: ${questionModel.id}');
    ListPathCubit soundsCubit = ListPathCubit(questionModel.listSound);

    if (kDebugMode) {
      print(questionModel.listSound);
    }
    ListPathCubit videosCubit = ListPathCubit(questionModel.listVideo);
    if (questionModel.answerState.isEmpty) {
      List<String> listAnswer = [];
      if (questionModel.a != "") {
        listAnswer.add(questionModel.a);
      }
      if (questionModel.b != "") {
        listAnswer.add(questionModel.b);
      }
      if (questionModel.c != "") {
        listAnswer.add(questionModel.c);
      }
      if (questionModel.d != "") {
        listAnswer.add(questionModel.d);
      }
      listAnswer.shuffle();
      questionModel.answerState = [...listAnswer];
    }
    return Column(children: [
      Expanded(
        flex: 4,
        child: Card(
          margin: CustomPadding.questionCardPadding(context),
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
              side: const BorderSide(color: Color(0xffE0E0E0), width: 1)),
          child: Center(
            child: CustomScrollBar(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (questionModel.question != "")
                    QuestionCustom(
                      question: questionModel.question,
                    ),
                  if (questionModel.video != "")
                    BlocBuilder<ListPathCubit, String>(
                        bloc: videosCubit..load(),
                        builder: (_, String video) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 30),
                                  vertical: Resizable.padding(context, 5)),
                              child: Column(
                                children: [
                                  VideoView(url: video, dir: bloc.dir),
                                  if (questionModel.listVideo.length > 1)
                                    NextBackWidget(() {
                                      videosCubit.next();
                                    }, () {
                                      videosCubit.prev();
                                    },
                                        text:
                                            '${videosCubit.index + 1}/${videosCubit.size}'),
                                ],
                              ));
                        }),
                  if (questionModel.image != "")
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 30),
                            vertical: Resizable.padding(context, 5)),
                        child: ImageList(questionModel.listImage, dir: bloc.dir)),
                  if (questionModel.sound != "")
                    BlocBuilder<ListPathCubit, String>(
                        bloc: soundsCubit..load(),
                        builder: (_, String sound) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 30),
                                  vertical: Resizable.padding(context, 5)),
                              child: Column(
                                children: [
                                  BlocProvider(
                                    key: Key(questionModel.id.toString()),
                                    create: (context) => SoundCubit(),
                                    child: BlocBuilder<SoundCubit, double>(
                                      builder: (context, state) {
                                        final SoundCubit soundCubit =
                                            context.read<SoundCubit>();
                                        return Sounder1(
                                          CustomCheck.getAudioLink(sound, bloc.dir),
                                          iconColor: primaryColor,
                                          size: 20,
                                          q: questionModel,
                                          soundCubit: soundCubit,
                                          soundType: 'download',
                                        );
                                      },
                                    ),
                                  ),
                                  if (questionModel.listSound.length > 1)
                                    NextBackWidget(() {
                                      soundsCubit.next();
                                    }, () {
                                      soundsCubit.prev();
                                    },
                                        text:
                                            '${soundsCubit.index + 1}/${soundsCubit.size}'),
                                ],
                              ));
                        }),
                  if (questionModel.paragraph != "") ...[
                    ParagraphView(questionModel: questionModel)
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 6,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 15),
            ).copyWith(top: Resizable.padding(context, 10)),
            child: CustomScrollBar(
              child: Column(children: [
                ...questionModel.answerState
                    .map((item) => Selector(
                            item, questionModel.isSelected(item), () async {
                          if (listEquals(questionModel.answered, [item])) {
                            return;
                          }
                          questionModel.answered = [item];
                          bloc.add(UpdateEvent());

                          await BaseSharedPreferences.savePracticeData(
                              questionModel, type,bloc.id, bloc.resultId);

                          bloc.autoSkip(() {
                            btvnUtils.autoNext(
                                context, questionModel.questionType,bloc.dataId,bloc.id,bloc.classId,bloc.userId, bloc.resultId);
                          });
                        }, questionModel.questionType))
                    ,
              ]),
            ),
          ),
        ),
      )
    ]);
  }
}

class ListPathCubit extends Cubit<String> {
  final List<String> listPath;
  int index = 0;

  int get size => listPath.length;

  ListPathCubit(this.listPath) : super("");

  load() {
    if (size != 0) {
      emit(listPath[0]);
    }
  }

  next() {
    if (index < size) {
      index++;
      emit(listPath[index]);
    }
  }

  prev() {
    if (index != 0) {
      index--;
      emit(listPath[index]);
    }
  }
}
