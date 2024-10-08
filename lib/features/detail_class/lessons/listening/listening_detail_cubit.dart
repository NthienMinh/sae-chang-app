import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/models/skill_models/lesson.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';
import 'package:sae_chang/providers/download/listening_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/services/download_controller.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'listening_cubit.dart';

class ListeningDetailCubit extends Cubit<int> {
  ListeningDetailCubit(this.cubit)
      : super(0);
  final repo = ListeningProvider.instance;
  final media = MediaService.instance;

  final ListeningCubit? cubit;
  Duration? position;
  Duration? duration;
  Lesson? lesson;
  int? idHighLight;
  bool isPlay = false;
  Duration? durationEndWhenClick;
  AutoScrollController? controller;

  void emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  load(Duration p, Lesson item) async {

    Functions.logDebug('load: load');
    position = p;
    lesson = item;
    if(cubit != null) {
      await cubit!.getData();
    }

    var temp = await FireBaseProvider.instance.getLessonById(item.lessonId);

    var course =
    await FireBaseProvider.instance.getCourseByIds([temp.courseId]);

    String dir = await DownLoadController.getDownloadFolder(
        item.lessonId, "listening", course.first.dataVersion);

    final pathAudio = item.pathAudio.isNotEmpty ? item.pathAudio :
    repo.getUrlAudioById( lesson!.id.toString(),dir);

    final player = media.newPlayer(pathAudio, 'file');
    player.addListener(() {
      if (durationEndWhenClick != null &&
          player.value.position.compareTo(durationEndWhenClick!) >= 0) {
        pause();
      }
      if (player.value.duration == player.value.position &&
          player.value.position.inMilliseconds.toDouble() != 0) {
        controller!.scrollToIndex(0, preferPosition: AutoScrollPosition.end);
        position = Duration.zero;
        pause();
        player.seekTo(position!);
      }
      duration = player.value.duration;
      position = player.value.position;
      isPlay = player.value.isPlaying;
      getIdHighLight();
      emitState();
    });
    player.play();
  }

  void pause() async {
    durationEndWhenClick = null;
    try {
      media.getPlayer().pause();
    }
    catch (e){
      await load(Duration.zero, lesson!);
      media.getPlayer().pause();
    }
    emitState();
  }

  void play() async {
    try {
      media.getPlayer().play();
    }
    catch (e){
      await load(Duration.zero, lesson!);
    }
    emitState();
  }
  Future onSeek(Duration d, bool value) async {
    try {
      await media.getPlayer().seekTo(d);
    }
    catch (e){
      await load(Duration.zero, lesson!);
      await media.getPlayer().seekTo(d);
    }
    emitState();
    if (value) {
      play();
    }
  }

  void dispose() {
    media.getPlayer().dispose();
  }

  void getIdHighLight() {
    final time = position!.inMilliseconds.toDouble();
    final index = lesson!.sentences.indexWhere(
            (item) => item.end * 100 - 1 > time && time > item.start * 100);
    if (index == -1) {
      idHighLight = -1;
    } else if (lesson!.sentences[index].id != idHighLight) {
      idHighLight = lesson!.sentences[index].id;
      controller!.scrollToIndex(index, preferPosition: AutoScrollPosition.end);
    }
    emitState();
  }

  void clickMessage(Sentences sen) {
    onSeek(Duration(milliseconds: sen.start * 100), true).then((value) =>
    durationEndWhenClick = Duration(milliseconds: sen.end * 100));
  }

}