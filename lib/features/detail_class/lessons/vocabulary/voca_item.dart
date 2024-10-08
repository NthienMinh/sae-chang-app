import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/vocabulary/vocabulary_cubit.dart';
import 'package:sae_chang/models/skill_models/word.dart';
import 'package:sae_chang/providers/download/vocabulary_provider.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

import 'circle_button_play_sound.dart';

class VocaItem extends StatelessWidget {
  const VocaItem({super.key, required this.word, required this.cubit});
  final Word word;
  final VocabularyCubit cubit;
  @override
  Widget build(BuildContext context) {
    final repo = VocabularyProvider.instance;
    return Container(
        constraints: const BoxConstraints(minHeight: 170),
        margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 3)),
        decoration: BoxDecoration(
            color: word.isMemorize ? primaryColor : whiteColor,
            border: Border.all(color: primaryColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0.0, 0.0),
                spreadRadius: 0,
                blurRadius: 5.0,
              )
            ],
            borderRadius: BorderRadius.circular(Resizable.size(context, 20))),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
            onTap: () async {
              // await Navigator.pushNamed(context, Routes.wordDetail, arguments: {
              //   'listWordCubit': cubit,
              //   'word': word,
              // });
              //
              // await cubit.getData();
              //
            },
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(
                    File(
                      word.pathImage.isNotEmpty
                          ? word.pathImage
                          : repo.getUrlImageById(
                              word.id.toString(), "", cubit.dir),
                    ),
                    height: 150,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/img_logo.png',
                      height: 150,
                    ),
                  ),
                )),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SplitTextCustom(
                        text: word.word.trim(),
                        phoneticSize: 14,
                        kanjiFW: FontWeight.bold,
                        kanjiSize: 25,
                        isTitle: !word.isMemorize,
                        kanjiColor:
                            word.isMemorize ? Colors.white : Colors.black,
                      ),
                      AutoSizeText(
                        '(${word.type.toLowerCase().trim()}.) /${word.phonetic}/',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 13),
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CircleButtonPlaySound(
                        word: word,
                        size: const Size(35, 35),
                        playSound: false,
                        dir: cubit.dir,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AutoSizeText(word.mean,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: Resizable.font(context, 16),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 45,
                )
              ],
            ),
          ),
        ));
  }
}
