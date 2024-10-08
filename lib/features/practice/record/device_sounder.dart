import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../bloc/sound_cubit.dart';


class DeviceSounder extends StatelessWidget {
  const DeviceSounder(
      {super.key,
      this.size = 20,
      required this.index,
      required this.path,
      required this.onDelete,
      required this.soundCubit});
  final int index;
  final String path;
  final double size;
  final Function() onDelete;
  final SoundCubit soundCubit;

  @override
  Widget build(BuildContext context) {
    var isTablet = Resizable.isTablet(context);
    return Container(
      key: Key(path),
        height: Resizable.size(context, 45),
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(Resizable.size(context, 30)),
        ),
        margin: EdgeInsets.symmetric(
            vertical: Resizable.padding(context, 5),
            horizontal: Resizable.padding(context, isTablet ? 40 : 20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BlocBuilder<SoundCubit, double>(
                  bloc: soundCubit,
                  builder: (cc, p) {
                    return Row(
                      children: [
                        InkWell(
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 50)),
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: Resizable.size(context, 20)),
                                child: (p == -2 ||
                                            soundCubit.activeFilePath != path)
                                    ? Icon(Icons.volume_up,
                                        color: Colors.white,
                                        size: Resizable.size(context, size))
                                    : p == -1 &&
                                            soundCubit.activeFilePath == path
                                        ? Icon(Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: Resizable.size(context, size))
                                        : p == 0 &&
                                                soundCubit.activeFilePath == path
                                            ? SizedBox(
                                                height:
                                                    Resizable.size(context, size),
                                                width:
                                                    Resizable.size(context, size),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            :
                                soundCubit.activeFilePath ==
                                                        path
                                                ? Icon(Icons.pause,
                                                    color: Colors.white,
                                                    size: Resizable.size(
                                                        context, size))
                                                : Icon(Icons.volume_up,
                                                    color: Colors.white,
                                                    size: Resizable.size(
                                                        context, size))),
                            onTap: () async {
                              debugPrint('=>>>>>>>>ttt${soundCubit.activeFilePath}');
                              debugPrint('=>>>>>>>>ttt$path');
                              if (soundCubit.activeFilePath != path) {
                                debugPrint('=>>>>>>>>soundCubit $path');
                                MediaService.instance.playSound(path,  soundCubit, "download");
                              }
                              if (p == -1 && soundCubit.activeFilePath == path) {
                                MediaService.instance.resume( soundCubit);
                              }
                              if (p > 0 && soundCubit.activeFilePath == path) {
                                MediaService.instance.pause(soundCubit);
                              }
                            }),
                        soundCubit.activeFilePath != path
                            ? Text(' File thu âm ${index + 1}',
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 16),
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white))
                            : Flexible(
                                child: Slider(
                                    key: Key("${soundCubit.duration}"),
                                    activeColor: primaryColor.shade300,
                                    inactiveColor: Colors.grey.shade100,
                                    thumbColor: Colors.white,
                                    min: -2,
                                    max: soundCubit.duration,
                                    value: p == 0
                                        ? -2
                                        : p == -1
                                            ? soundCubit.currentPosition
                                            : p,
                                    onChanged: (value) async {
                                      final position =
                                          Duration(milliseconds: value.toInt());
                                      await MediaService.instance.seek(position);
                                    }),
                              ),
                        SizedBox(width: Resizable.padding(context, 20),)
                      ],
                    );
                  }),
            ),
            Padding(
                padding: EdgeInsets.only(right: Resizable.padding(context, 15)),
                child: GestureDetector(
                    onTap: onDelete,
                    child: Image.asset(
                      "assets/icons/ic_delete.png",
                      height: Resizable.size(context, 25),
                      width: Resizable.size(context, 25),
                    )))
          ],
        ));
  }
}

class TeacherSounder extends StatelessWidget {
  final String sound;
  final double size;
  final double elevation;
  final Color backgroundColor;
  final Color iconColor;
  final SoundCubit soundCubit;
  final int type;
  final String soundType;
  final int index;
  const TeacherSounder(this.sound, this.soundType, this.index,
      {super.key,
        this.size = 18,
        this.elevation = 2,
        this.backgroundColor = Colors.white,
        this.iconColor = Colors.white,
        this.type = 0,
        required this.soundCubit,
        });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(sound),
      height: Resizable.size(context, 45),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Resizable.size(context, 100)),
        border: Border.all(color: primaryColor)
      ),
      margin: EdgeInsets.symmetric(
        vertical: Resizable.padding(context, 5),
        horizontal: Resizable.padding(context, 10)
      ),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 10)
      ),
      child: BlocBuilder<SoundCubit, double>(
          bloc: soundCubit,
          builder: (cc, p) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                        borderRadius:
                        BorderRadius.circular(Resizable.size(context, 50)),
                        child: Container(
                            padding: EdgeInsets.only(
                                left: Resizable.size(context, 10)),
                            child: (soundCubit.activeFilePath != sound)
                                ? Icon(Icons.volume_up,
                                color: primaryColor,
                                size: Resizable.size(context, size))
                                : MediaService.instance.isPause() == true &&
                                soundCubit.activeFilePath == sound
                                ? Icon(Icons.play_arrow_rounded,
                                color: primaryColor,
                                size: Resizable.size(context, size))
                                : p == 0 &&
                                soundCubit.activeFilePath == sound
                                ? SizedBox(
                              height:
                              Resizable.size(context, size),
                              width:
                              Resizable.size(context, size),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            )
                                : MediaService.instance.isPause() ==
                                false &&
                                soundCubit.activeFilePath ==
                                    sound
                                ? Icon(Icons.pause,
                                color: primaryColor,
                                size: Resizable.size(
                                    context, size))
                                : Icon(Icons.volume_up,
                                color: primaryColor,
                                size: Resizable.size(
                                    context, size))),
                        onTap: () async {
                          if (soundCubit.activeFilePath != sound) {
                            MediaService.instance
                                .playSound(sound, soundCubit, soundType);
                          }
                          if (MediaService.instance.isPause() == true &&
                              soundCubit.activeFilePath == sound) {
                            MediaService.instance.play();
                          } else if (MediaService.instance.isPause() == false &&
                              soundCubit.activeFilePath == sound) {
                            MediaService.instance.pause(soundCubit);
                          }
                        }),
                    SizedBox(width: Resizable.padding(context, 5),),
                    Text(
                        'File chú thích ${index + 1}',
                        style: TextStyle(
                            fontSize: Resizable.font(context, 16),
                            fontWeight: FontWeight.w800,
                            color: primaryColor)),
                    SizedBox(width: Resizable.padding(context, 20),),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
