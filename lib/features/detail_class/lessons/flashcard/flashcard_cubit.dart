import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';
import 'package:sae_chang/models/skill_models/word.dart';
import 'package:sae_chang/providers/download/flashcard_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/services/download_controller.dart';
import 'package:sae_chang/services/media_service.dart';

class FlashCardCubit extends Cubit<int> {
  FlashCardCubit(
      this.context, this.lessonId, this.swiperController, this.soundCubit,
      {required this.type})
      : super(0);
  final BuildContext context;
  final int lessonId;
  final SwiperController swiperController;
  final SoundCubit soundCubit;
  // List<FlashCardModel> listFl = [];
  final String type;
  final repo = FlashCardProvider.instance;
  List<FlashCardModel> listFlashcard = [];
  // List<FlashCardModel> listBase = [];
  // List<FlashCardModel> listShuffle = [];
  int indexCurrent = 0;
  String folder = '';
  Timer? timer;
  int time = 0;
  double timeAutoPlay = 5;
  Map<String, String> maps = {};
  int indexShowAll = 0;
  int indexAutoPlay = 0;
  int indexShuffle = 0;
  int indexTypeFlashcard = 0;
  bool isLoading = false;
  String dir = "";

  onNext() {
    time = 0;
    swiperController.next(animation: true);
    MediaService.instance.stop();
    soundCubit.reStart();
  }

  onPrevious() {
    time = 0;
    swiperController.previous(animation: true);
    MediaService.instance.stop();
    soundCubit.reStart();
  }

  void stopTimer() {
    time = 0;
    timer?.cancel();
  }

  void startTimer() {
    // return;
    if (indexAutoPlay == 0) {
      stopTimer();
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint('-----> periodic ${timer.tick.toString()}');
      debugPrint('-----> autoplay $timeAutoPlay');
      debugPrint(
          '=====> timer ${MediaService.instance.checkExist().toString()}');

      if (isClosed) {
        timer.cancel();
        return;
      }
      if (MediaService.instance.isPause() ||
          !MediaService.instance.checkExist()) {
        time++;
        if (time % timeAutoPlay == 0) {
          onNext();
        }
      }
    });
  }

  update(int index) {
    indexCurrent = index;
    emit(state + 1);
  }

  load() async {
    isLoading = false;
    String token = '';

    var lesson = await FireBaseProvider.instance.getLessonById(lessonId);

    var course =
        await FireBaseProvider.instance.getCourseByIds([lesson.courseId]);
    token = course.first.dataToken;

    String dir = await DownLoadController.getDownloadFolder(
        lessonId, "flashcard", course.first.dataVersion);

    this.dir = dir;
    if (context.mounted) {
      await repo.downloadFile(
          context, lessonId, token, course.first.dataVersion);
    }
    listFlashcard = await repo.getFlashcards(dir);
    startTimer();
    isLoading = true;
    if (isClosed) return;
    emit(state + 1);
  }

  convertWordToFlashcard(List<Word> listWords) async {
    isLoading = false;

    var lesson = await FireBaseProvider.instance.getLessonById(lessonId);

    var course =
    await FireBaseProvider.instance.getCourseByIds([lesson.courseId]);

    String dir = await DownLoadController.getDownloadFolder(
        lessonId, "vocabulary", course.first.dataVersion);

    this.dir = dir;
    // if (context.mounted) {
    //   await repo.downloadFile(
    //       context, lessonId, token, course.first.dataVersion);
    // }
    for (var item in listWords) {
      listFlashcard.add(item.wordFlashcard);
    }

    startTimer();
    isLoading = true;
    if (isClosed) return;
    emit(state + 1);
  }
}
