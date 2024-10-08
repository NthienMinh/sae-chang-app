import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/shared_preferences.dart';

class TimeCustomCubit extends Cubit<int> {
  TimeCustomCubit(this.classId,this.lessonId, this.skill) : super(0) {
    load();
  }

  final int lessonId;
  final int classId;
  final String skill;
  final localRepo = SharePreferencesListProvider.instance;
  int time = 0;
  bool isActive = false;

  Timer? timer;
  String? fileSaved;
  String? keyFlip;

  void startTimer() {
    if (isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time = timer.tick;
    });
    isActive = true;
  }

  Future<String> getSkillTime() async {
    return 'class_${classId}_lesson_${lessonId}_skill_${skill}_time';
  }

  Future<String> getKeyFlip() async {
    var key =
        'class_${classId}_lesson_${lessonId}_flip_flashcard';
    return key;
  }

  Future stopTimer() async {
    if (!isActive) return;
    timer?.cancel();
    await BaseSharedPreferences.setString(
        fileSaved!, (await timeSaved() + time).toString());

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
    if (fileSaved == null) return;
    await BaseSharedPreferences.removeJsonToPref(fileSaved!);
  }

  Future saveIdFlip(int id) async {
    await localRepo.insert(keyFlip!, id.toString());
  }

  void load() async {
    fileSaved = await getSkillTime();

    keyFlip = await getKeyFlip();
  }
}