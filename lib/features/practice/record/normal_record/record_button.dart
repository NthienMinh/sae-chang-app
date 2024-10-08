


import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/bloc/voice_record_cubit.dart';
import 'package:sae_chang/features/practice/record/normal_record/voice_record_view.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class RecordButton extends StatelessWidget {
  const RecordButton(
      {super.key,
      required this.isRecord,
      required this.voiceRecordCubit,
      required this.questionModel,
      required this.bloc,
      required this.recordingStateCubit,
      required this.soundCubit, required this.type});
  final bool isRecord;
  final VoiceRecordCubit voiceRecordCubit;
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final RecordStateCubit recordingStateCubit;
  final SoundCubit soundCubit;
  final String type;
  @override
  Widget build(BuildContext context) {
    return isRecord
        ? Transform.translate(
            offset: Offset(0, -Resizable.size(context, 15)),
            child: AvatarGlow(
                glowColor: primaryColor,
                endRadius: Resizable.size(context, 70),
                child: Card(
                    margin: EdgeInsets.symmetric(
                        vertical: Resizable.size(context, 10)),
                    shadowColor: primaryColor,
                    elevation: Resizable.size(context, 2),
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 50))),
                    child: InkWell(
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 50)),
                        child: AvatarGlow(
                          endRadius: Resizable.size(context, 45),
                          child: Container(
                              margin:
                                  EdgeInsets.all(Resizable.size(context, 10)),
                              padding:
                                  EdgeInsets.all(Resizable.size(context, 10)),
                              child: Icon(Icons.mic,
                                  size: Resizable.size(context, 50),
                                  color: Colors.white)),
                        ),
                        onTap: () async {
                          MediaService.instance.pause(soundCubit);
                          await voiceRecordCubit.stopRecord(
                              questionModel, bloc, type);
                          recordingStateCubit.change();
                        }))),
          )
        : Card(
            margin: EdgeInsets.symmetric(vertical: Resizable.size(context, 10)),
            shadowColor: primaryColor,
            elevation: Resizable.size(context, 2),
            color: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 50))),
            child: InkWell(
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 50)),
                child: Container(
                    margin: EdgeInsets.all(Resizable.size(context, 10)),
                    padding: EdgeInsets.all(Resizable.size(context, 10)),
                    child: Icon(Icons.mic,
                        size: Resizable.size(context, 50),
                        color: Colors.white)),
                onTap: () async {
                  MediaService.instance.stop();
                  soundCubit.reStart();
                  var res = await voiceRecordCubit.startRecord(
                      DateTime.now().millisecondsSinceEpoch.toString());
                  if(res) {
                    recordingStateCubit.change();
                  }
                  else {
                    return;
                  }
                }));
  }
}