import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/shared_preferences.dart';

class TimePracticeCubit extends Cubit<int> {
  TimePracticeCubit(this.id,this.resultId, this.type) : super(0) {
    load();
  }

  int time = 0;
  bool isActive = false;
  final int id, resultId;
  final String type;
  Timer? timer;
  String? fileSaved;
  String? fileHistoryQuestionDoing;
  bool isConfirmSubmit = false;
  void startTimer() {
    if (isActive || isConfirmSubmit) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time = timer.tick;
    });
    isActive = true;
  }


  Future stopTimer(int idQuesCurrent) async {

    if (!isActive) return;
    timer?.cancel();
    await BaseSharedPreferences.setString(
        fileSaved!, (await timeSaved() + time).toString());
    await BaseSharedPreferences.setString(
        fileHistoryQuestionDoing!, idQuesCurrent.toString());
    time = 0;
    isActive = false;
  }

  Future<int> timeSaved() async {
    final time = await BaseSharedPreferences.getString(fileSaved!);
    if (time.isEmpty) {
      return 0;
    } else {
      return int.parse(time);
    }
  }
  Future removeFileSaved() async {
    if(fileSaved == null) return;
    await BaseSharedPreferences.removeJsonToPref(fileSaved!);
    await BaseSharedPreferences.removeJsonToPref(fileHistoryQuestionDoing!);
  }
  void load() async {
    fileSaved = await BaseSharedPreferences.getKey(type , id, resultId, 'time');
    fileHistoryQuestionDoing = await BaseSharedPreferences.getKey(type , id, resultId, 'history');
  }

}