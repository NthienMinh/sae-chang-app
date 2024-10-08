import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class FlashCardSound extends StatelessWidget {
  final String sound;
  final SoundCubit soundCubit;
  final String path;
  final bool isPlayFirst;
  final Color iconColor;
  final bool isPracticeSpeaking;
  final double size;
  final int start;
  final int end;

  const FlashCardSound(
      {super.key,
      required this.sound,
      this.iconColor = primaryColor,
      this.isPracticeSpeaking = false,
      required this.soundCubit,
      this.path = '',
      this.start = -1,
      this.end = -1,
      this.isPlayFirst = false,
      this.size = 20});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoundCubit, double>(
        key: Key(sound),
        bloc: soundCubit
          ..play(sound, path, soundCubit, isPlayFirst,
              isPracticeSpeaking: isPracticeSpeaking),
        builder: (cc, p) {
          return InkWell(
              borderRadius:
                  BorderRadius.circular(Resizable.size(context, size + 30)),
              child: Container(
                  margin: EdgeInsets.all(Resizable.size(context, 10)),
                  child: (p == -2 ||
                          soundCubit.activeFilePath !=
                              CustomCheck.getAudioLink(sound, path))
                      ? Icon(Icons.volume_up,
                          color: iconColor, size: Resizable.size(context, size))
                      : p == 0 &&
                              soundCubit.activeFilePath ==
                                  CustomCheck.getAudioLink(sound, path)
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
                                  soundCubit.activeFilePath ==
                                      CustomCheck.getAudioLink(sound, path)
                              ? Icon(Icons.play_arrow_rounded,
                                  color: iconColor,
                                  size: Resizable.size(context, size))
                              : soundCubit.activeFilePath ==
                                      CustomCheck.getAudioLink(sound, path)
                                  ? Icon(Icons.pause,
                                      color: iconColor,
                                      size: Resizable.size(context, size))
                                  : Icon(Icons.volume_up,
                                      color: iconColor,
                                      size: Resizable.size(context, size))),
              onTap: () {
                if (soundCubit.activeFilePath !=
                    CustomCheck.getAudioLink(sound, path)) {
                  MediaService.instance.playSound(
                      CustomCheck.getAudioLink(sound, path), soundCubit, "file",
                      isPracticeSpeaking: isPracticeSpeaking);
                }
                if (p == -1 &&
                    soundCubit.activeFilePath ==
                        CustomCheck.getAudioLink(sound, path)) {
                  MediaService.instance.resume(soundCubit);
                }
                if (p > 0 &&
                    soundCubit.activeFilePath ==
                        CustomCheck.getAudioLink(sound, path)) {
                  MediaService.instance.pause(soundCubit);
                }
              });
        });
  }
}
