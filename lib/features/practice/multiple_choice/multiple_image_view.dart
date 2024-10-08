import 'package:flutter/Material.dart';
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
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/shared_preferences.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_scroll_bar.dart';
import 'package:sae_chang/widgets/next_back_widget.dart';

import 'image_list.dart';
import 'multiple_choice_view.dart';

class MultipleImageView extends StatelessWidget {
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final String type;
  MultipleImageView(
      {super.key,
      required this.questionModel,
      required this.bloc,
      required this.type,})
      : soundCubit = SoundCubit();
  final SoundCubit soundCubit;
  @override
  Widget build(BuildContext context) {
    ListPathCubit soundsCubit = ListPathCubit(questionModel.listSound);
    ListPathCubit videosCubit = ListPathCubit(questionModel.listVideo);
    if (questionModel.answerState.isEmpty) {
      questionModel.answerState = [
        questionModel.a,
        questionModel.b,
        questionModel.c,
        questionModel.d
      ];
      questionModel.answerState.shuffle();
    }
    return Column(
        children: [
          Expanded(
            flex: 4,
            child:  Card(
              elevation: 5,
              margin: CustomPadding.questionCardPadding(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
                  side: const BorderSide(color: Color(0xffE0E0E0), width: 1)),
              child: Center(
                child: CustomScrollBar(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (questionModel.question != "")
                        QuestionCustom(question: questionModel.question,),
                      if (questionModel.video != "")
                        BlocBuilder<ListPathCubit, String>(
                            bloc: videosCubit..load(),
                            builder: (_, String video) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      top: Resizable.padding(context, 30),
                                      left: Resizable.padding(context, 30),
                                      right: Resizable.padding(context, 30)),
                                  child: Column(
                                    children: [
                                      VideoView(url: video, dir: bloc.dir),
                                      if (questionModel.listVideo.length != 1)
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
                            padding: EdgeInsets.only(top: Resizable.padding(context, 30), bottom: Resizable.padding(context, 10)),
                            child: ImageList(questionModel.listImage, dir: bloc.dir)),
                      if (questionModel.sound != "")
                        BlocBuilder<ListPathCubit, String>(
                            bloc: soundsCubit..load(),
                            builder: (_, String sound) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      top: Resizable.padding(context, 30),
                                      left: Resizable.padding(context, 30),
                                      right: Resizable.padding(context, 30)),
                                  child: Column(
                                    children: [
                                      Sounder1(
                                        CustomCheck.getAudioLink(sound, bloc.dir),
                                        iconColor: primaryColor,
                                        size: 20,
                                        soundCubit: soundCubit,
                                        soundType: 'download',
                                        q:questionModel,
                                      ),
                                      if (questionModel.listSound.length != 1)
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                left: Resizable.padding(context, 30),
                right: Resizable.padding(context, 30),
                top: Resizable.padding(context, 20),

              ),

              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                crossAxisSpacing: Resizable.padding(
                    context, 15),
                mainAxisSpacing: Resizable.padding(
                    context, 15), // 2 items per row
              ),
              itemCount: questionModel.answerState.length,
              itemBuilder: (BuildContext context, int index) {
                var e = questionModel.answerState[index];
                return  ImageSelector(
                    e, questionModel.isSelected(e), () async {
                  questionModel.answered = [e];
                  bloc.add(UpdateEvent());
                  BaseSharedPreferences.savePracticeData(
                      questionModel, type, bloc.id, bloc.resultId);
                }, () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(Routes.fullScreen, arguments: {
                    'imageList': questionModel.answerState,
                    'init': questionModel.answerState.indexOf(e),
                    'type': "download",
                    'dir': bloc.dir
                  });
                }, dir: bloc.dir);
              },
            ),
            SizedBox(height:  Resizable.height(context) * 0.15,)
          ],
        ),
      )
      ]);
  }
}
