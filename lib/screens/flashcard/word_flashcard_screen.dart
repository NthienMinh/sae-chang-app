import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_view.dart';
import 'package:sae_chang/models/skill_models/word.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/widgets/custom_appbar.dart';

import 'flashcard_screen.dart';

class WordFlashCardScreen extends StatefulWidget {
  const WordFlashCardScreen(
      {super.key, required this.listWord, required this.lessonId});
  final List<Word> listWord;

  final int lessonId;

  @override
  State<WordFlashCardScreen> createState() => _WordFlashCardScreenState();
}

class _WordFlashCardScreenState extends State<WordFlashCardScreen> {
  final HideButtonCubit hideButtonCubit = HideButtonCubit();
  final SwiperController swiperController = SwiperController();
  final SoundCubit soundCubit = SoundCubit();

  @override
  void dispose() {
    MediaService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: MyAppBar(AppText.txtFlashcard.text.toUpperCase(), context),
          body: BlocProvider(
            create: (context) => FlashCardCubit(
                context, widget.lessonId, swiperController, soundCubit,
                type: 'vocabulary')
              ..convertWordToFlashcard(widget.listWord),
            child: BlocBuilder<FlashCardCubit, int>(builder: (cc, i) {
              if (i == 0) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              final flashCardCubit = BlocProvider.of<FlashCardCubit>(cc);
              return FlashCardView(
                flashCardCubit: flashCardCubit,
                hideButtonCubit: hideButtonCubit,
                swiperController: swiperController,
                soundCubit: soundCubit,
              );
            }),
          ),
        ),
      ],
    );
  }
}
