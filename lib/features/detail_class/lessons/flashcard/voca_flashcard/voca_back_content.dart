import 'package:flutter/Material.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/voca_flashcard/voca_back_content_type_1.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';

class VocBackContent extends StatelessWidget {
  const VocBackContent(
      {super.key,
      required this.flashCardCubit,
      required this.flashCardModel,
      required this.soundCubit,
      required this.indexFlashcard});

  final FlashCardModel flashCardModel;
  final SoundCubit soundCubit;
  final int indexFlashcard;
  final FlashCardCubit flashCardCubit;

  @override
  Widget build(BuildContext context) {
    return VocabBackContentType1(
            flashCardModel: flashCardModel,
            soundCubit: soundCubit,
            flashCardCubit: flashCardCubit)
        //   indexFlashcard == 0 ? VocabBackContentType1(
        //   flashCardModel: flashCardModel,
        //   soundCubit: soundCubit,
        // ) : indexFlashcard == 1 ? VocabBackContentType2(
        //   flashCardModel: flashCardModel,
        //   soundCubit: soundCubit,
        // ) : VocabBackContentType2(
        //   flashCardModel: flashCardModel,
        //   soundCubit: soundCubit,
        // )
        ;
  }
}
