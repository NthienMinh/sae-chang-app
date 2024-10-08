
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/listening_effect_cubit/listening_effect_cubit.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/animated_button.dart';

import 'circle_button_effect.dart';

class ListeningDetailAction extends StatelessWidget {
  const ListeningDetailAction({super.key});

  @override
  Widget build(BuildContext context) {


    List<EffectModel> list = [
      EffectModel('assets/icons/ic_tapescript.png', 1),
      EffectModel('assets/icons/ic_translate.png',2),
      EffectModel('assets/icons/ic_transcription.png', 3),
      EffectModel('assets/icons/ic_speed.png', 4),
    ];
    final effectCubit =
        context.watch<ListeningEffectCubit>().state as ListeningEffectLoaded;
    return Flexible(
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20)
        ),
        physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: Resizable.padding(context, 10),
            childAspectRatio: 1
          ),
          itemCount: 4,
          itemBuilder: (context , index) {
            return  AnimatedButton(
              child: CircleButtonEffect(
                asset: list[index].asset,
                color: getEffect(effectCubit, list[index].index) ? primaryColor : darkGreyColor,
                index: list[index].index,
              ),
            );
          }),
    );
  }

  bool getEffect(ListeningEffectLoaded effectCubit, int index) {
    switch(index) {
      case 1: return effectCubit.isBlur;
      case 2: return effectCubit.isTranslate;
      case 3: return effectCubit.isPhonetic;
      default: return effectCubit.isSpeed;
    }
  }
}

class EffectModel {
  final String asset;
  final int index;
  EffectModel(this.asset, this.index);

}
