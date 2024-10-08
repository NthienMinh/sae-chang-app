import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/bloc/voice_record_cubit.dart';
import 'package:sae_chang/features/practice/paragraph_view.dart';
import 'package:sae_chang/features/practice/record/role_play/record_state_view.dart';
import 'package:sae_chang/features/practice/record/role_play/role_play_sounder.dart';
import 'package:sae_chang/features/practice/record/role_play/script_view.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/models/base_model/role_play_sentence_model.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../../../../widgets/custom_scroll_bar.dart';
import '../device_sounder.dart';

class RolePlayView extends StatelessWidget {
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final List<RolePlaySentenceModel> sentences;
  final String type;

  RolePlayView(
      {super.key,
      required this.questionModel,
      required this.bloc,
      required this.voiceRecordCubit,
      required this.type})
      : recordingStateCubit = RolePlayStateCubit(),
        sentences = RolePlaySentenceModel.fromScript(questionModel.question),
        soundCubit = SoundCubit();

  final VoiceRecordCubit voiceRecordCubit;
  final RolePlayStateCubit recordingStateCubit;
  final SoundCubit soundCubit;

  @override
  Widget build(BuildContext context) {
    List<File> listVoices = [];
    if (questionModel.answered.isNotEmpty) {
      for (var element in questionModel.answered) {
        listVoices.add(File(element));
      }
    }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Center(
                      child: CustomScrollBar(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (questionModel.paragraph != "") ...[
                                ParagraphView(questionModel: questionModel)
                              ],
                              if (sentences.isNotEmpty)
                                Transform.translate(
                                  offset: Offset(0, Resizable.padding(context, 15)),
                                  child: ScriptView(
                                    soundCubit: soundCubit,
                                    sentences: sentences,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20)),
                    child: RolePlaySounder(
                      soundCubit: soundCubit,
                      voiceRecordCubit: voiceRecordCubit,
                      recordingStateCubit: recordingStateCubit,
                      questionModel: questionModel,
                      bloc: bloc,
                      type: type,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 6,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RecordStateView(
                      recordingStateCubit: recordingStateCubit,
                    ),
                    BlocBuilder<VoiceRecordCubit, List<File>>(
                        bloc: voiceRecordCubit..load(listVoices),
                        builder: (c, voices) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 20,
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
                            ],
                          );
                        }),
                    SizedBox(
                      height: Resizable.height(context) * 0.05,
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
