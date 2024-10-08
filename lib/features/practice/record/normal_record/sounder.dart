import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class Sounder1 extends StatelessWidget {
  final String sound;
  final double size;
  final double elevation;
  final Color backgroundColor;
  final Color iconColor;
  final SoundCubit soundCubit;
  final int type;
  final String soundType;
  final QuestionModel q;
  const Sounder1(this.sound,
      {super.key,
      this.size = 20,
      this.elevation = 2,
      this.backgroundColor = Colors.white,
      this.iconColor = Colors.white,
      this.type = 0,
      required this.soundCubit, required this.soundType, required this.q});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: Key(sound),
      height: Resizable.size(context, 50),
      child: Card(
          shadowColor: primaryColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: iconColor,
              ),
              borderRadius: BorderRadius.circular(Resizable.size(context, 30))),
          child: BlocBuilder<SoundCubit, double>(
              bloc: soundCubit,
              builder: (cc, p) {
                return (soundCubit.questionId == null || soundCubit.questionId != q.id) ? Row(
                  children: [
                    GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(
                                left: Resizable.size(context, 20)),
                            child: Icon(Icons.volume_up,
                                color: iconColor,
                                size: Resizable.size(context, size))),
                        onTap: () async {
                          soundCubit.updateQuestionId(q.id);
                          MediaService.instance.playSound(sound, soundCubit, soundType);
                          // if (p == -1 && soundCubit.activeFilePath == sound) {
                          //   debugPrint('=>>>>>>>recoredrecored');
                          //   MediaService.instance.resume(soundCubit);
                          // }
                          // if (p > 0 && soundCubit.activeFilePath == sound) {
                          //   MediaService.instance.pause(soundCubit);
                          // }
                        }),
                    Flexible(
                      child: Slider(
                          key: Key("${soundCubit.duration}"),
                          activeColor: iconColor,
                          inactiveColor: primaryColor.shade300,
                          min: 0,
                          max: soundCubit.duration,
                          value: 0,
                          onChanged: (value) async {

                          }),
                    )
                  ],
                ) : Row(
                  children: [
                    GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(
                                left: Resizable.size(context, 20)),
                            child: (p == -2 ||
                                    soundCubit.activeFilePath != sound)
                                ? Icon(Icons.volume_up,
                                    color: iconColor,
                                    size: Resizable.size(context, size))
                                : p == 0 &&
                                        soundCubit.activeFilePath == sound
                                    ? SizedBox(
                                        height: Resizable.size(context, size),
                                        width: Resizable.size(context, size),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: iconColor,
                                          ),
                                        ),
                                      )
                                    : p == -1 &&
                                            soundCubit.activeFilePath == sound
                                        ? Icon(Icons.play_arrow_rounded,
                                            color: iconColor,
                                            size: Resizable.size(context, size))
                                        : soundCubit.activeFilePath == sound
                                            ? Icon(Icons.pause,
                                                color: iconColor,
                                                size: Resizable.size(
                                                    context, size))
                                            : Icon(Icons.volume_up,
                                                color: iconColor,
                                                size: Resizable.size(
                                                    context, size))),
                        onTap: () async {
                          // soundCubit.updateQuestionId(q.id);
                          if (soundCubit.activeFilePath != sound) {
                            debugPrint('=>>>>>>>recoredrecored');
                            MediaService.instance
                                .playSound(sound, soundCubit, soundType);
                          }
                          if (p == -1 && soundCubit.activeFilePath == sound) {
                            debugPrint('=>>>>>>>recoredrecored');
                            MediaService.instance.resume(soundCubit);
                          }
                          if (p > 0 && soundCubit.activeFilePath == sound) {
                            MediaService.instance.pause(soundCubit);
                          }
                        }),
                    Flexible(
                      child: Slider(
                          key: Key("${soundCubit.duration}"),
                          activeColor: iconColor,
                          inactiveColor: primaryColor.shade300,
                          min: -2,
                          max: soundCubit.duration,
                          value: p == 0 || soundCubit.activeFilePath != sound
                              ? -2
                              : p == -1
                                  ? soundCubit.currentPosition > soundCubit.duration ? soundCubit.duration : soundCubit.currentPosition
                                  : p,
                          onChanged: (value) async {
                            final position =
                                Duration(milliseconds: value.toInt());
                            await MediaService.instance.seek(position);
                          }),
                    )
                  ],
                );
              })),
    );
  }
}


