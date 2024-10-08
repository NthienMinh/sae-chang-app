import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/listening_effect_cubit/listening_effect_cubit.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ColumnTextPhonetic extends StatelessWidget {
  const ColumnTextPhonetic({
    super.key,
    required this.isHighLight,
    required this.effectCubit,
    required this.cons,
  });
  final bool isHighLight;
  final ListeningEffectLoaded effectCubit;
  final Sentences cons;

  @override
  Widget build(BuildContext context) {
    var color = !isHighLight ? primaryColor : whiteColor;
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SplitTextCustom(
          text: cons.sentence,
          foreground: effectCubit.isBlur ? null : paint,
          kanjiColor: color,
          kanjiSize: 17,
          phoneticSize: 11,
          phoneticColor: color != whiteColor ? Colors.black : color,
          isParagraph: true,
        ),
        if (effectCubit.isPhonetic)
          SplitTextCustom(
            text: cons.phonetic.replaceAll("\n", ""),
            foreground: effectCubit.isBlur ? null : paint,
            kanjiColor: color,
            kanjiSize: 17,
            phoneticSize: 11,
            phoneticColor: color != whiteColor ? Colors.black : color,
            isParagraph: true,
          )
      ],
    );


  }
}
