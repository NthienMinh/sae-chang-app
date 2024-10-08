import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/practice/multiple_choice/image_list.dart';
import 'package:sae_chang/features/practice/multiple_choice/multiple_choice_view.dart';
import 'package:sae_chang/features/practice/record/normal_record/sounder.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_button.dart';
import 'package:sae_chang/widgets/next_back_widget.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../configs/app_configs.dart';
import '../../../../widgets/custom_scroll_bar.dart';
import '../../../../widgets/drawings.dart';
import '../paragraph_view.dart';
import '../question_custom.dart';
import 'drawing_board.dart';

class DrawView extends StatelessWidget {
  final QuestionModel questionModel;
  final DrawCubit drawCubit;
  final String path;
  final PracticeBloc bloc;
  final DrawingsController drawController;

  DrawView(
      {super.key,
      required this.questionModel,
      required this.path,
      required this.bloc,
      required this.screenshotController,
      required this.drawController})
      : drawCubit = DrawCubit();
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    drawController.clear();

    ListPathCubit soundsCubit = ListPathCubit(questionModel.listSound);
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Card(
            elevation: 5,
            margin: CustomPadding.questionCardPadding(context),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 20)),
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
            child: Padding(
              padding: CustomPadding.questionCardPadding(context).copyWith(
                top: Resizable.padding(context, 20)
              ),
              child: LayoutBuilder(builder: (context, h) {
                return Column(
                  children: [
                    BlocBuilder<DrawCubit, String>(
                        bloc: drawCubit..load(path),
                        builder: (c, p) {
                          if (p == "") {
                            return Stack(
                              children: [
                                Card(
                                  margin: EdgeInsets.only(
                                      right: Resizable.size(context, 15)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Resizable.size(context, 20)),
                                      side: const BorderSide(
                                          color: primaryColor, width: 1)),
                                  child: Screenshot(
                                    controller: screenshotController,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          "assets/icons/ic_bg_draw.png",
                                          width: double.infinity,
                                          height: h.maxHeight - Resizable.height(context) * 0.05,
                                          fit: BoxFit.fill,
                                        ),
                                        Positioned.fill(
                                            child: DrawingBoard(
                                                height: h.maxHeight - Resizable.height(context) * 0.05,
                                                controller: drawController)),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: DrawPanelController(
                                        erase: drawController.clear,
                                        revert: drawController.revert),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Stack(
                            children: [
                              Stack(children: [
                                IgnorePointer(
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Resizable.size(context, 15)),
                                        side: const BorderSide(
                                            color: primaryColor, width: 1)),
                                    child: Image.file(
                                      File(path),
                                      width: double.infinity,
                                      height: h.maxHeight - Resizable.height(context) * 0.05,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ]),
                              Positioned.fill(
                                bottom: 10,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      width: Resizable.size(context, 100),
                                      child: CustomButton(
                                        title: AppText.txtReDraw.text,
                                        onTap: () async {
                                          drawCubit.load("");
                                          questionModel.answered = [];
                                          //bloc.add(UpdateEvent());
                                          AppConfigs.countDraw++;
                                        },
                                        backgroundColor: primaryColor,
                                        textColor: Colors.white,
                                        height: 35,
                                      ),
                                    )),
                              )
                            ],
                          );
                        }),
                  ],
                );
              }),
            )),
      ],
    );
  }
}

class DrawCubit extends Cubit<String> {
  DrawCubit() : super("");

  load(String path) {
    emit(path);
  }


}
