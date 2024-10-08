import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/custom_check.dart';

class SoundCubit extends Cubit<double> {
  SoundCubit() : super(-2);
  int? questionId;
  bool playFirst = true;
  String activeFilePath = '';
  String activeFileType = '';
  double currentPosition = 0;
  double duration = Duration.zero.inMilliseconds.toDouble();

  change(double newPosition) {
    debugPrint("==============> change $newPosition");
    emit(newPosition);
  }

  changeActive(String type, String sound) {
    activeFileType = type;
    activeFilePath = sound;
  }

  loading() {
    emit(0);
  }

  pause() {
    debugPrint("==============> pause");
    emit(-1);
  }

  reStart() {
    debugPrint('restart');
    emit(-2);
    activeFilePath = "";
    activeFileType = "";

    questionId = null;
  }

  updateQuestionId(int id) {
    questionId = id;
    emit(-3);
  }

  updateDuration(double value) {
    duration = value;
    emit(-10);
  }

  play(String sound, String path, SoundCubit soundCubit, bool isPlayFirst, {bool isPracticeSpeaking = false}) {
    if(playFirst) {
      playFirst = false;
      MediaService.instance.playSound(
          CustomCheck.getAudioLink(sound, path), soundCubit, "download", isPracticeSpeaking: isPracticeSpeaking);

    }
  }
}