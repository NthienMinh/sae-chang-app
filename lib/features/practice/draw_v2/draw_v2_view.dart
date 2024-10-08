import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/practice/draw/drawing_board.dart';
import 'package:sae_chang/features/practice/multiple_choice/image_list.dart';
import 'package:sae_chang/features/practice/multiple_choice/multiple_choice_view.dart';
import 'package:sae_chang/features/practice/record/normal_record/sounder.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/loading_progress.dart';
import 'package:sae_chang/widgets/next_back_widget.dart';

import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_scroll_bar.dart';
import '../paragraph_view.dart';
import '../question_custom.dart';

class DrawV2View extends StatelessWidget {
  final QuestionModel questionModel;
  final PracticeBloc bloc;

  DrawV2View({
    super.key,
    required this.questionModel,
    required this.bloc,
  }) :  cubit = DrawV2Cubit(bloc.digitalInkRecognizer, bloc.ink, questionModel);
  final DrawV2Cubit cubit;
  @override
  Widget build(BuildContext context) {
    ListPathCubit soundsCubit = ListPathCubit(questionModel.listSound);
    return BlocBuilder<DrawV2Cubit, int>(
      bloc: cubit.._downloadModel(context),
      builder: (context, state) {
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
                    side:
                        const BorderSide(color: Color(0xffE0E0E0), width: 1)),
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
              child: state == 0
                  ? const LoadingProgress()
                  : Padding(
                      padding:
                          CustomPadding.questionCardPadding(context).copyWith(
                        top: Resizable.padding(context, 20),
                        bottom: Resizable.padding(context, 20),
                      ),
                      child: LayoutBuilder(builder: (context, c) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: Resizable.padding(context, cubit.isDrew ? 0 :15)),
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/icons/ic_bg_draw.png",
                                      ),
                                      fit: BoxFit.fill),
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(15)),
                              child: GestureDetector(


                                onPanStart: (DragStartDetails details) {
                                  var position = details.localPosition;
                                  cubit._ink.strokes.add(Stroke());
                                  cubit.points = List.from(cubit.points)
                                    ..add(StrokePoint(
                                      x: position.dx,
                                      y: position.dy,
                                      t: DateTime.now()
                                          .millisecondsSinceEpoch,
                                    ));
                                  if (cubit._ink.strokes.isNotEmpty) {
                                    cubit._ink.strokes.last.points =
                                        cubit.points.toList();
                                  }
                                  cubit.emitState();
                                },
                                onPanUpdate: (DragUpdateDetails details) {
                                  var position = details.localPosition;
                                  if (position.dx >= c.minWidth + Resizable.padding(context, 10) &&
                                      position.dx <= c.maxWidth - Resizable.padding(context, 20) &&
                                      position.dy >= Resizable.padding(context, 10) &&
                                      position.dy <= c.maxHeight - Resizable.padding(context, 10)) {
                                    cubit.points = List.from(cubit.points)
                                      ..add(StrokePoint(
                                        x: position.dx,
                                        y: position.dy,
                                        t: DateTime.now()
                                            .millisecondsSinceEpoch,
                                      ));
                                  }

                                  if (cubit._ink.strokes.isNotEmpty) {
                                    cubit._ink.strokes.last.points =
                                        cubit.points.toList();
                                  }
                                  cubit.emitState();
                                },
                                onPanEnd: (DragEndDetails details) {
                                  cubit.points.clear();
                                  cubit.emitState();
                                },
                                dragStartBehavior: DragStartBehavior.down,
                                child: CustomPaint(
                                  painter: Signature(ink: cubit._ink),
                                  size: Size.infinite,
                                ),
                              ),
                            ),
                            if(!cubit.isDrew)
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: DrawPanelController(erase: () {
                                  cubit.clearPad();
                                }, revert: () {
                                  cubit.revert();
                                }),
                              ),
                            ),
                            if(cubit.isDrew)
                              Positioned.fill(
                                bottom: 10,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      width: Resizable.size(context, 100),
                                      child: CustomButton(
                                        title: AppText.txtReDraw.text,
                                        onTap: () async {
                                          questionModel.answered = [];
                                          questionModel.answerState = [];
                                          cubit.isDrew = false;
                                          cubit.clearPad();
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
                    ),
            ),
          ],
        );
      },
    );
  }
}

class DrawV2Cubit extends Cubit<int> {
  DrawV2Cubit(this.digitalInkRecognizer, this._ink, this.model)
      : super(0);

  final QuestionModel model;
  var language = 'ja';
  final DigitalInkRecognizer digitalInkRecognizer;
  final Ink _ink;
  List<StrokePoint> points = [];
  String recognizedText = '';
  bool isDrew = false;
  Future<void> _downloadModel(BuildContext context) async {
    loadPoints();
    emit(state + 1);
  }

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  clearPad() {
    _ink.strokes.clear();
    points.clear();
    recognizedText = '';
    emitState();
  }

  revert() {
    if (_ink.strokes.isNotEmpty) {
      _ink.strokes.removeLast();
    }
    if (points.isNotEmpty) {
      points.removeLast();
    }
    emitState();
  }

  loadPoints() {
    for (var item in model.answerState) {
      points.clear();
      _ink.strokes.add(Stroke());
      var k = jsonDecode(item);
      for(var i in k['points'])  {
        points.add(StrokePoint(x: i['x'], y: i['y'], t: i['t']));
      }
      _ink.strokes.last.points = points.toList();
    }
    if(_ink.strokes.isNotEmpty) {
      isDrew = true;
    }
  }
}

class Signature extends CustomPainter {
  Ink ink;

  Signature({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = primaryColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 7.0;

    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        var current  = Offset(p1.x.toDouble(), p1.y.toDouble());
        var next  = Offset(p2.x.toDouble(), p2.y.toDouble());
        canvas.drawLine( current, next, paint);
      }
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}