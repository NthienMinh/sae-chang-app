import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/listening_effect_cubit/listening_effect_cubit.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../../../configs/color_configs.dart';
import 'column_text_phonetic.dart';
import 'listening_detail_cubit.dart';

class MessageCenter extends StatelessWidget {
  const MessageCenter({super.key, required this.cons});
  final Sentences cons;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ListeningDetailCubit>();
    final effectCubit =
        context.watch<ListeningEffectCubit>().state as ListeningEffectLoaded;
    return BlocBuilder<ListeningDetailCubit, int>(
      bloc: cubit,
      builder: (_, __) {
        bool isHighLight = cubit.idHighLight == cons.id;
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: Resizable.width(context) * 0.8,
            ),
            decoration: BoxDecoration(
                color: isHighLight ? primaryColor : whiteColor,
                border: Border.all(color: primaryColor),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 4)
                ]),
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            margin: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: () async {
                cubit.clickMessage(cons);
              },
              child: effectCubit.isTranslate
                  ? Column(
                      children: [
                        rowPhoneticText(isHighLight, effectCubit),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(cons.mean,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 15),
                                color: !isHighLight
                                    ? greyColor.shade600
                                    : whiteColor)),
                      ],
                    )
                  : Column(
                      children: [
                        rowPhoneticText(isHighLight, effectCubit),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  rowPhoneticText(bool isHighLight, ListeningEffectLoaded effectCubit) {
    return ColumnTextPhonetic(
        isHighLight: isHighLight, effectCubit: effectCubit, cons: cons);
  }
}
