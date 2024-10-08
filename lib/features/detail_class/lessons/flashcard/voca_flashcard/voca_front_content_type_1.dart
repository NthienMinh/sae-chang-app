import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flascard_sound.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flip_title.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/untils/split_text.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class VocabFrontContentType1 extends StatelessWidget {
  const VocabFrontContentType1({
    super.key,
    required this.flashCardModel,
    required this.soundCubit,
    required this.flashCardCubit,
  });

  final FlashCardModel flashCardModel;
  final FlashCardCubit flashCardCubit;
  final SoundCubit soundCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: Resizable.padding(context, 50),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // if (flashCardCubit != null)
                //   StarMemory(
                //     flashCardCubit: flashCardCubit!,
                //     flashCardModel: flashCardModel,
                //     soundCubit: soundCubit,
                //   ),
                flashCardModel.soundFront.isEmpty
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000)),
                        child: Builder(builder: (context) {
                          var id =
                              '${SplitText().getId(flashCardModel.soundFront)}.mp3';
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlashCardSound(
                                sound: id,
                                soundCubit: soundCubit,
                                isPlayFirst: true,
                                path: flashCardCubit.dir,
                              ),
                            ],
                          );
                        }),
                      ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Resizable.padding(context, 5),
              horizontal: Resizable.padding(context, 20),
            ),
            child: Builder(builder: (context) {
              var value = flashCardModel.titleFront;

              Functions.logDebug(value);
              var textN = '';
              int lastPipeIndex = value.lastIndexOf('|');

              if (lastPipeIndex != -1) {
                textN = value.substring(lastPipeIndex + 1, value.length).trim();
                value = value.substring(0, lastPipeIndex);
              }

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SplitTextCustom(
                        text: value.trim(),
                        kanjiSize: 30,
                        phoneticSize: 15,
                        isTitle: true,
                        kanjiColor: primaryColor,
                        kanjiFW: FontWeight.w700,
                      ),
                      if (textN.isNotEmpty)
                        AutoSizeText("[$textN]",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 14))),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: Resizable.padding(context, 10),
        ),
        flashCardModel.imageFront.isEmpty ||
                (!File(CustomCheck.getFlashCardImage(
                            flashCardModel.imageFront, flashCardCubit.dir))
                        .existsSync() &&
                    !File(flashCardModel.imageFront).existsSync())
            ? Container()
            : SizedBox(
                height: Resizable.size(context, 130),
                width: Resizable.size(context, 130),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5)),
                      side: const BorderSide(color: Colors.black, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Flexible(child: Builder(builder: (context) {
                          return Center(
                            child: Image.file(
                              File(File(flashCardModel.imageFront).existsSync()
                                  ? flashCardModel.imageFront
                                  : CustomCheck.getFlashCardImage(
                                      flashCardModel.imageFront,
                                      flashCardCubit.dir)),
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/icons/ic_not_found.png'),
                            ),
                          );
                        }))
                      ],
                    ),
                  ),
                ),
              ),
        Expanded(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 20)),
                  child: Builder(builder: (context) {
                    var listSen = flashCardModel.textFront.split('\n');
                    listSen.removeWhere((element) => element.isEmpty);
                    return Column(
                      children: [
                        ...listSen.asMap().entries.map((e) {
                          return SplitTextCustom(
                            text: e.value,
                            kanjiSize: 20,
                            phoneticSize: 11,
                          );
                        })
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        )),
        const FlipTitle(isFront: true)
      ],
    );
  }
}
