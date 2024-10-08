import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/bloc/voice_record_cubit.dart';
import 'package:sae_chang/features/practice/record/device_sounder.dart';
import 'package:sae_chang/features/practice/record/normal_record/record_button.dart';
import 'package:sae_chang/features/practice/record/normal_record/timer_view.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../../../../widgets/custom_scroll_bar.dart';
import '../../../../../widgets/next_back_widget.dart';
import '../../multiple_choice/image_list.dart';
import '../../paragraph_view.dart';
import '../../question_custom.dart';
import 'sounder.dart';
import '../../multiple_choice/multiple_choice_view.dart';

class VoiceRecordView extends StatelessWidget {
  final QuestionModel questionModel;

  VoiceRecordView({
    super.key,
    required this.questionModel,
    required this.bloc,
    required this.voiceRecordCubit,
    required this.type,
  })  : soundCubit = SoundCubit();
  final VoiceRecordCubit voiceRecordCubit;
  final SoundCubit soundCubit;
  final PracticeBloc bloc;
  final String type;

  @override
  Widget build(BuildContext context) {
    List<File> listVoices = [];
    if (questionModel.answered.isNotEmpty) {
      for (var element in questionModel.answered) {
        listVoices.add(File(element));
      }
    }
    var key = Key(questionModel.id.toString());
    return Column(
      key: key,
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
                    if (questionModel.paragraph != "") ...[
                      ParagraphView(questionModel: questionModel)
                    ],
                    if (questionModel.sound != "")
                      BlocProvider(
                        create: (context) =>
                            ListPathCubit(questionModel.listSound),
                        key: key,
                        child: BlocBuilder<ListPathCubit, String>(
                            builder: (c, String sound) {
                          final soundsCubit = c.read<ListPathCubit>();
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: Resizable.padding(context, 20),
                                  bottom: Resizable.padding(context, 30),
                                  left: Resizable.padding(context, 30),
                                  right: Resizable.padding(context, 30)),
                              child: Column(
                                children: [
                                  Sounder1(
                                    CustomCheck.getAudioLink(questionModel.sound, bloc.dir),
                                    iconColor: primaryColor,
                                    size: 20,
                                    soundCubit: soundCubit,
                                    soundType: "download",
                                    q: questionModel,
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
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<VoiceRecordCubit, List<File>>(
                      bloc: voiceRecordCubit..load(listVoices),
                      builder: (c, voices) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocProvider(
                              create: (context) => RecordStateCubit(),
                              key: key,
                              child: BlocBuilder<RecordStateCubit, bool>(
                                  builder: (cc, isRecord) {
                                debugPrint('recordingStateCubit');
                                final RecordStateCubit recordingStateCubit =
                                    cc.read<RecordStateCubit>();
                                return Column(
                                  children: [
                                    RecordButton(
                                      isRecord: isRecord,
                                      voiceRecordCubit: voiceRecordCubit,
                                      questionModel: questionModel,
                                      bloc: bloc,
                                      recordingStateCubit: recordingStateCubit,
                                      soundCubit: soundCubit,
                                      type: type,
                                    ),
                                    if (isRecord)
                                      TimerView(
                                        key: key,
                                      ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                Resizable.padding(context, 10)),
                                        child: Text(
                                          isRecord
                                              ? AppText
                                                  .txtTapToEndRecord.text
                                              : AppText
                                                  .txtTapToRecord.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize:
                                                  Resizable.size(context, 15)),
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                );
                              }),
                            ),
                            ...voices.map((e) => DeviceSounder(
                                  index: voices.indexOf(e),
                                  path: e.path,
                                  onDelete: () {
                                    MediaService.instance.stop();
                                    voiceRecordCubit.removeRecord(
                                        e, questionModel, bloc, type);
                                  },
                                  soundCubit: soundCubit,
                                )),
                            SizedBox(
                              height: Resizable.height(context) * 0.05,
                            )
                          ],
                        );
                      })
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class RecordStateCubit extends Cubit<bool> {
  RecordStateCubit() : super(false) {
    if (kDebugMode) {
      print('RecordStateCubit load');
    }
  }

  change() {
    debugPrint('kkkkkkkkkk , $state');
    emit(!state);
  }
}
