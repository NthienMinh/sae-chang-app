import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/voca_flashcard/voca_back_content.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';
import 'package:sae_chang/screens/flashcard/flashcard_screen.dart';

import 'flashcard_cubit.dart';

class BackContent extends StatelessWidget {
  const BackContent(
      {super.key,
      required this.flashCardModel,
      required this.soundCubit,
      required this.flashCardCubit,
      required this.swiperController,
      required this.hideButtonCubit,
      required this.indexFlashcard});

  final FlashCardModel flashCardModel;
  final SoundCubit soundCubit;
  final int indexFlashcard;
  final FlashCardCubit flashCardCubit;
  final SwiperController swiperController;
  final HideButtonCubit hideButtonCubit;

  @override
  Widget build(BuildContext context) {
    return VocBackContent(
      flashCardModel: flashCardModel,
      soundCubit: soundCubit,
      indexFlashcard: indexFlashcard,
      flashCardCubit: flashCardCubit,
    );
    //
    // flashCardModel.skillId == 7
    //   ? ReadingBackContent(
    //       flashCardModel: flashCardModel,
    //       soundCubit: soundCubit,
    //       indexFlashcard: indexFlashcard)
    //   : flashCardModel.skillId == 6
    //       ? ListeningBackContent(
    //           flashCardModel: flashCardModel,
    //           soundCubit: soundCubit,
    //           indexFlashcard: indexFlashcard)
    //       : flashCardModel.skillId == 2
    //           ? GrammarBackContent(
    //               flashCardModel: flashCardModel, soundCubit: soundCubit)
    //           : VocBackContent(
    //               flashCardModel: flashCardModel,
    //               soundCubit: soundCubit,
    //               indexFlashcard: indexFlashcard,
    //             );
  }
}
