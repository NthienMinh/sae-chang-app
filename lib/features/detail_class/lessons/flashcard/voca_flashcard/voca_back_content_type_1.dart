import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flascard_sound.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flip_title.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/untils/split_text.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class VocabBackContentType1 extends StatelessWidget {
  const VocabBackContentType1(
      {super.key,
      required this.flashCardModel,
      required this.soundCubit,
      required this.flashCardCubit});

  final FlashCardModel flashCardModel;
  final SoundCubit soundCubit;
  final FlashCardCubit flashCardCubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Resizable.padding(context, 50),
              child: flashCardModel.soundBack.isEmpty
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, right: 20),
                        child: Container(
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
                                '${SplitText().getId(flashCardModel.soundBack)}.mp3';
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlashCardSound(
                                  sound: id,
                                  isPlayFirst: true,
                                  soundCubit: soundCubit,
                                  path: flashCardCubit.dir,
                                ),
                              ],
                            );
                          }),
                        ),
                      )),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(context, 5),
                  horizontal: Resizable.padding(context, 20),
                ),
                child: Builder(builder: (context) {
                  var value = flashCardModel.titleFront;
                  int lastPipeIndex = value.lastIndexOf('|');
                  if (lastPipeIndex != -1) {
                    value = value.substring(0, lastPipeIndex);
                  }

                  RegExp regExp = RegExp(r'{(.*?)}');
                  List<String> matches = regExp
                      .allMatches(value)
                      .map((match) => match.group(1)!)
                      .toList();
                  matches.add(value.replaceAll(regExp, '').trim());
                  matches.removeWhere((element) => element.isEmpty);
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
                          AutoSizeText(flashCardModel.titleBack,
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
            Expanded(
                flex: 1,
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
                            var listVie = flashCardModel.textBack.split('\n');
                            return Column(
                              children: [
                                ...listSen.asMap().entries.map((e) {
                                  return SplitTextCustom(
                                    text: e.value,
                                    kanjiSize: 20,
                                    phoneticSize: 11,
                                    vText: e.key < listVie.length
                                        ? listVie[e.key]
                                        : '',
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
            const FlipTitle(isFront: false)
          ],
        ),
      ],
    );
  }
}
