
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/listening_effect_cubit/listening_effect_cubit.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'column_text_phonetic.dart';
import 'listening_detail_cubit.dart';
class MessageLeft extends StatelessWidget {
  const MessageLeft({super.key, required this.cons});
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 3),
                          blurRadius: 4
                      )
                    ]
                ),
                child: CircleAvatar(
                    radius: Resizable.size(context, 20),
                    foregroundColor: isHighLight ? Colors.white : primaryColor,
                    backgroundColor: isHighLight ? primaryColor : Colors.white,
                    child: AutoSizeText(cons.character, maxLines: 2, overflow: TextOverflow.ellipsis,)),
              ),
            ),
            SizedBox(width: Resizable.padding(context, 10),),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: Resizable.width(context) * 0.8,
                ),
                decoration: BoxDecoration(
                  color: isHighLight ? primaryColor : whiteColor,
                  border: Border.all(color: primaryColor),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 4
                    )
                  ]
                ),
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                margin: const EdgeInsets.only(bottom: 20),

                child: InkWell(
                  onTap: () async {
                    cubit.clickMessage(cons);
                  },
                  child: effectCubit.isTranslate
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            rowPhoneticText(isHighLight, effectCubit),
                            const SizedBox(height: 3,),
                            Text(
                              cons.mean,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 15),
                                  color: !isHighLight
                                      ? greyColor.shade600
                                      : whiteColor)
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            rowPhoneticText(isHighLight, effectCubit),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  rowPhoneticText(bool isHighLight, ListeningEffectLoaded effectCubit) {
   return ColumnTextPhonetic(isHighLight: isHighLight, effectCubit: effectCubit, cons: cons);
  }
}