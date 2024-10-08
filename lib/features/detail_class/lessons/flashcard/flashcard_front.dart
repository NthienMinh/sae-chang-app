import 'package:flutter/Material.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/voca_flashcard/voca_front_content.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';

import 'flashcard_cubit.dart';

class FrontContent extends StatelessWidget {
  const FrontContent(
      {super.key,
      required this.flashCardModel,
      required this.soundCubit,
      required this.flashCardCubit,
      required this.indexFlashcard});

  final FlashCardModel flashCardModel;
  final FlashCardCubit flashCardCubit;
  final SoundCubit soundCubit;
  final int indexFlashcard;

  @override
  Widget build(BuildContext context) {
    return VocFrontContent(
        flashCardModel: flashCardModel,
        soundCubit: soundCubit,
        indexFlashcard: indexFlashcard,
        flashCardCubit: flashCardCubit);
    // flashCardModel.skillId == 7
    //     ? ReadingFrontContent(
    //         flashCardModel: flashCardModel,
    //         soundCubit: soundCubit,
    //         flashCardCubit: flashCardCubit,
    //         indexFlashcard: indexFlashcard)
    //     : flashCardModel.skillId == 6
    //         ? ListeningFrontContent(
    //             flashCardModel: flashCardModel,
    //             soundCubit: soundCubit,
    //             flashCardCubit: flashCardCubit,
    //             indexFlashcard: indexFlashcard)
    //         : flashCardModel.skillId == 2
    //             ? GrammarFrontContent(
    //                 flashCardModel: flashCardModel,
    //                 soundCubit: soundCubit,
    //                 flashCardCubit: flashCardCubit,
    //                 indexFlashcard: indexFlashcard,
    //               )
    //             : VocFrontContent(
    //                 flashCardModel: flashCardModel,
    //                 soundCubit: soundCubit,
    //                 indexFlashcard: indexFlashcard,
    //                 flashCardCubit: flashCardCubit,
    //               );
  }
}
