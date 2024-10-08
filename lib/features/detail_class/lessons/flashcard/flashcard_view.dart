import 'package:card_swiper/card_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/screens/flashcard/flashcard_screen.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/flashcard_next_back_widget.dart';
import 'package:sae_chang/widgets/loading_progress.dart';

import 'card_side.dart';
import 'flashcard_back.dart';
import 'flashcard_cubit.dart';
import 'flashcard_front.dart';

class FlashCardView extends StatefulWidget {
  FlashCardView(
      {super.key,
        required this.flashCardCubit,
        required this.hideButtonCubit,
        required this.swiperController,
        required this.soundCubit,
        this.timeCubit,})
      : flipCardController = FlipCardController();
  final SwiperController swiperController;
  final SoundCubit soundCubit;
  final FlashCardCubit flashCardCubit;
  final FlipCardController flipCardController;
  final HideButtonCubit hideButtonCubit;
  final TimeCustomCubit? timeCubit;


  @override
  State<FlashCardView> createState() => _FlashCardViewState();
}

class _FlashCardViewState extends State<FlashCardView>
    with LifecycleAware, LifecycleMixin {
  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if (widget.timeCubit == null) return;
    if (event == LifecycleEvent.push ||
        event == LifecycleEvent.visible ||
        event == LifecycleEvent.active) {
      widget.timeCubit!.startTimer();
    } else {
      await widget.timeCubit!.stopTimer();
    }
  }

  @override
  void dispose() {
    widget.flashCardCubit.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.flashCardCubit.isLoading) {
      return const LoadingProgress();
    }
    return Column(
      children: [
        SizedBox(
          height: Resizable.padding(context, 10),
        ),

        Expanded(
          flex: 5,
          child: widget.flashCardCubit.listFlashcard.isEmpty
              ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chúc mừng bạn \nđã hoàn thành phần flashcard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 20),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/icons/ic_congratulation.png',
                    height: Resizable.size(context, 50),
                  )
                ],
              ))
              : Swiper(
              key: Key("${widget.flashCardCubit.listFlashcard.length}"),
              onIndexChanged: (index) {
                widget.soundCubit.playFirst = true;
                if (MediaService.instance.checkExist()) {
                  MediaService.instance.stop();
                  widget.soundCubit.reStart();
                }
                widget.flashCardCubit.update(index);
              },
              index: widget.flashCardCubit.indexCurrent,
              itemCount: widget.flashCardCubit.listFlashcard.length,
              viewportFraction: 1,
              itemBuilder: (context, index) {
                var model = widget.flashCardCubit
                    .listFlashcard[widget.flashCardCubit.indexCurrent];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context,
                          Resizable.isTablet(context) ? 40 : 25),
                      vertical: Resizable.padding(context, 0))
                      .copyWith(top: 0),
                  child: FlipCard(
                      controller: widget.flipCardController,
                      flipOnTouch: true,
                      onFlip: () {
                        if (widget.timeCubit != null &&
                            widget.flipCardController.state!.isFront) {
                          widget.timeCubit!.saveIdFlip(model.id);
                        }
                        MediaService.instance.stop();
                        widget.soundCubit.reStart();
                      },
                      front: CustomCardSide(
                        child: FrontContent(
                          flashCardModel: model,
                          soundCubit: widget.soundCubit,
                          flashCardCubit: widget.flashCardCubit,
                          indexFlashcard: widget
                              .flashCardCubit.indexTypeFlashcard,
                        ),
                      ),
                      back: CustomCardSide(
                        isBack: true,
                        child: BackContent(
                          flashCardModel: model,
                          soundCubit: widget.soundCubit,
                          flashCardCubit: widget.flashCardCubit,
                          swiperController: widget.swiperController,
                          hideButtonCubit: widget.hideButtonCubit,
                          indexFlashcard: widget
                              .flashCardCubit.indexTypeFlashcard,
                        ),
                      )),
                );
              },
              controller: widget.swiperController),
        ),

        // RowOptionsFlashCard(soundCubit: widget.soundCubit,flashCardCubit: widget.flashCardCubit),
        SizedBox(
          height: Resizable.padding(context, 50),
        ),
        BlocBuilder<FlashCardCubit, int>(
          bloc: widget.flashCardCubit,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.flashCardCubit.listFlashcard.isNotEmpty)
                      FlashcardNextBackWidget((_) {
                        widget.flashCardCubit.onNext();
                      }, (_) {
                        widget.flashCardCubit.onPrevious();
                      },
                          text:
                          '${widget.flashCardCubit.indexCurrent == -1 ? widget.flashCardCubit.listFlashcard.length : widget.flashCardCubit.indexCurrent + 1}/${widget.flashCardCubit.listFlashcard.length}'),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: Resizable.padding(context, 30),
        ),
      ],
    );
  }
}