import 'package:flutter/Material.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/voca_flashcard/voca_front_content_type_1.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';

class VocFrontContent extends StatelessWidget {
  const VocFrontContent(
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
    return VocabFrontContentType1(
      flashCardModel: flashCardModel,
      soundCubit: soundCubit,
      flashCardCubit: flashCardCubit,
    )
        //   indexFlashcard == 0
        //     ? VocabFrontContentType1(
        //   flashCardModel: flashCardModel,
        //   soundCubit: soundCubit,
        //   flashCardCubit: flashCardCubit,
        // )
        //     : indexFlashcard == 1
        //     ? VocabFrontContentType2(
        //   flashCardModel: flashCardModel,
        //   soundCubit: soundCubit,
        //   flashCardCubit: flashCardCubit,
        // )
        //     : VocabFrontContentType3(
        //   flashCardModel: flashCardModel,
        //   soundCubit: soundCubit,
        //   flashCardCubit: flashCardCubit,
        // )
        ;
  }
}
