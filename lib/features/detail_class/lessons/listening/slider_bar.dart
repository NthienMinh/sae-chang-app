import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'listening_detail_cubit.dart';


class SliderBar extends StatefulWidget {
  const SliderBar({super.key});

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ListeningDetailCubit>();
    var isTablet = Resizable.isTablet(context);
    return BlocBuilder<ListeningDetailCubit, int>(
      bloc: cubit,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child:  circlePlayer(cubit)),
              Flexible(
                child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: isTablet ? 2 : 0.5,
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 12.0),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                    ),
                    child: (cubit.duration == null ||
                            cubit.duration == Duration.zero)
                        ? Container()
                        : Slider(
                            value: cubit.position!.inMilliseconds.toDouble(),
                            max: cubit.duration!.inMilliseconds.toDouble(),
                            min: 0,
                            thumbColor: primaryColor,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              cubit.onSeek(
                                  Duration(milliseconds: value.toInt()), false);
                            },
                          )),
              ),
              Text(
                convertDuration(cubit.position!),
                style: TextStyle(
                    color: greyColor.shade600,
                    fontSize: Resizable.font(context, isTablet ? 15 : 12),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  String convertDuration(Duration duration) {
    String formattedDuration =
        '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    return formattedDuration;
  }

  circlePlayer(ListeningDetailCubit cubit) {
    return GestureDetector(
      onTap: () {
        if (cubit.isPlay) {
          cubit.pause();
        } else {
          cubit.play();
        }
      },
      child: Container(
              height: Resizable.size(
                  context, Resizable.isTablet(context) ? 40 : 30),
              width: Resizable.size(
                  context, Resizable.isTablet(context) ? 40 : 30),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child:Icon(
                cubit.isPlay
                    ? Icons.pause
                    : Icons.play_arrow_rounded,
                size: Resizable.size(context, Resizable.isTablet(context)  ? 30 : 20),
                color: whiteColor,
              ),
            ),
    );
  }
  circlePlayerShadowing(ListeningDetailCubit cubit) {
    return GestureDetector(
      onTap: () {
        if (cubit.isPlay) {
          cubit.pause();
        } else {
          cubit.play();
        }
      },
      child: cubit.isPlay
          ? AvatarGlow(
          glowColor: primaryColor,
          endRadius: Resizable.size(context, 30),
          child: Card(
              margin: EdgeInsets.symmetric(
                  vertical: Resizable.size(context, 0)),
              shadowColor: primaryColor,
              elevation: Resizable.size(context, 5),
              color: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(Resizable.size(context, 1000))),
              child: AvatarGlow(
                endRadius: Resizable.size(context, 20),
                child: Icon(Icons.mic,
                    size: Resizable.size(context, 20),
                    color: Colors.white),
              )))
          : SizedBox(
        height: Resizable.size(
            context, Resizable.isTablet(context) ? 60 : 60),
        width: Resizable.size(
            context, Resizable.isTablet(context) ? 60 : 60),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
        height: Resizable.size(
                  context, Resizable.isTablet(context) ? 40 : 40),
        width: Resizable.size(
                  context, Resizable.isTablet(context) ? 40 : 40),
        decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Icon(
                Icons.play_arrow_rounded,
                size: Resizable.size(
                    context, Resizable.isTablet(context) ? 30 : 25),
                color: whiteColor,
        ),
      ),
              ],
            ),
          ),
    );
  }
}
