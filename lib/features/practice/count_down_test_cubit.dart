import 'dart:async';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/shared_preferences.dart';

class CountDownTestCubit extends Cubit<int> {
  CountDownTestCubit(this.testId, this.duration, this.onAutoSubmit) : super(0);

  final int testId;
  final int duration;
  final Function() onAutoSubmit;
  final localRepo = SharePreferencesListProvider.instance;
  int tempDuration = 0;
  bool isActive = false;

  Timer? timer;
  String? fileSaved;

  void emitState() {
    if(isClosed) return;
    emit(state + 1);
  }

  void startTimer() {
    if (isActive) return;
    isActive = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      tempDuration--;
      emitState();
      if (tempDuration == 0) {
        timer.cancel();
        await onAutoSubmit();
        await removeFileSaved();
      }
    });

  }

  Future<String> getKey() async {
    return 'test_${testId}_countdown';
  }

  Future stopTimer() async {
    if (!isActive) return;
    timer?.cancel();
    await BaseSharedPreferences.setString(
        fileSaved!, tempDuration.toString());
    debugPrint('countdown: ${await timeSaved()}');
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
    if (fileSaved == null) return;
    await BaseSharedPreferences.removeJsonToPref(fileSaved!);
  }

  void load() async {
    fileSaved = await getKey();
    tempDuration = await timeSaved();
    if(tempDuration == 0) {
      tempDuration = duration;

    }
  }
}