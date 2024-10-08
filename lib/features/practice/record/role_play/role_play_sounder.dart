import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/bloc/voice_record_cubit.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class RolePlaySounder extends StatelessWidget {
  const RolePlaySounder(
      {super.key,
      required this.soundCubit,
      required this.voiceRecordCubit,
      required this.recordingStateCubit,
      required this.questionModel,
      required this.bloc, required this.type});

  final SoundCubit soundCubit;
  final VoiceRecordCubit voiceRecordCubit;
  final RolePlayStateCubit recordingStateCubit;
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(Resizable.padding(context, 10)),
            child: SizedBox(
              height: Resizable.size(context, 50),
              child: Card(
                  shadowColor: primaryColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: primaryColor,
                      ),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 30))),
                  child: BlocBuilder<SoundCubit, double>(
                      bloc: soundCubit,
                      builder: (cc, p) {
                        debugPrint("==========> ${p == -1}");
                        debugPrint(
                            "==========> ${soundCubit.activeFilePath == "${bloc.dir}${questionModel.listSound.first}"}");
                        return Row(
                          children: [
                            GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: Resizable.size(context, 20)),
                                    child: (p == -2 ||
                                            soundCubit.activeFilePath !=
                                                "${bloc.dir}${questionModel.listSound.first}")
                                        ? Icon(Icons.volume_up,
                                            color: primaryColor,
                                            size: Resizable.size(context, 20))
                                        : p == 0 &&
                                                soundCubit.activeFilePath ==
                                                    "${bloc.dir}${questionModel.listSound.first}"
                                            ? SizedBox(
                                                height:
                                                    Resizable.size(context, 20),
                                                width:
                                                    Resizable.size(context, 20),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              )
                                            : p == -1 &&
                                                    soundCubit.activeFilePath ==
                                                        "${bloc.dir}${questionModel.listSound.first}"
                                                ? Icon(Icons.play_arrow_rounded,
                                                    color: primaryColor,
                                                    size: Resizable.size(
                                                        context, 20))
                                                : soundCubit.activeFilePath ==
                                                        "${bloc.dir}${questionModel.listSound.first}"
                                                    ? Icon(Icons.pause,
                                                        color: primaryColor,
                                                        size: Resizable.size(
                                                            context, 20))
                                                    : Icon(Icons.volume_up,
                                                        color: primaryColor,
                                                        size: Resizable.size(
                                                            context, 20))),
                                onTap: () async {
                                  debugPrint('alloaaaaaa');
                                  if (p == -2 ||
                                      soundCubit.activeFilePath !=
                                          "${bloc.dir}${questionModel.listSound.first}") {
                                    await voiceRecordCubit.clear(questionModel, type);
                                    MediaService.instance.playAndRecord(
                                        "${bloc.dir}${questionModel.listSound.first}",
                                        soundCubit,
                                        questionModel,
                                        bloc,
                                        recordingStateCubit,
                                        voiceRecordCubit, type);
                                  }
                                  if (p == -1 &&
                                      soundCubit.activeFilePath ==
                                          "${bloc.dir}${questionModel.listSound.first}") {
                                    MediaService.instance.resume(soundCubit);
                                    voiceRecordCubit.resumeRecorder();
                                    recordingStateCubit.change(1);
                                  }
                                  if (p > 0 &&
                                      soundCubit.activeFilePath ==
                                          "${bloc.dir}${questionModel.listSound.first}") {
                                    MediaService.instance.pause(soundCubit);
                                    voiceRecordCubit.pauseRecorder();
                                    recordingStateCubit.change(2);
                                  }
                                }),
                            Flexible(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: Resizable.size(context, 5),
                                    thumbColor: Colors.transparent,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 0.0)),
                                child: Slider(
                                    key: Key("${soundCubit.duration}"),
                                    activeColor: primaryColor,
                                    inactiveColor: primaryColor.shade300,
                                    min: -2,
                                    max: soundCubit.duration,
                                    value: p == 0 ||
                                            soundCubit.activeFilePath !=
                                                "${bloc.dir}${questionModel.listSound.first}"
                                        ? -2
                                        : p == -1
                                            ? soundCubit.currentPosition
                                            : p,
                                    onChanged: (value) async {}),
                              ),
                            )
                          ],
                        );
                      })),
            )),

      ],
    );
  }
}

