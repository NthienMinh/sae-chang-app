import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';
import 'package:sae_chang/models/skill_models/speaking.dart';
import 'package:sae_chang/untils/replace_text.dart';

import 'lesson.dart';

class FlashCardModel {
  final int id, lessonId, skillId;
  final String titleFront,
      titleBack,
      textFront,
      textBack,
      imageFront,
      imageBack,
      soundFront,
      soundBack,
      columnBack;
  bool? _isRemember;

  bool get remembered => _isRemember ?? false;

  set remembered(bool isRemember) {
    _isRemember = isRemember;
  }

  FlashCardModel({
    required this.id,
    required this.lessonId,
    required this.skillId,
    required this.titleFront,
    required this.titleBack,
    required this.textFront,
    required this.textBack,
    required this.imageFront,
    required this.imageBack,
    required this.soundFront,
    required this.soundBack,
    required this.columnBack,
  });

  factory FlashCardModel.fromMap(Map<String, dynamic> json) => FlashCardModel(
      id: json['id'],
      lessonId: json['lesson_id'] == null
          ? 0
          : int.parse(json['lesson_id'].toString()),
      skillId: json['skill_id'] ?? 0,
      textFront: ReplaceText.replaceCharacterJapan(json['text_f'] ?? ''),
      textBack: ReplaceText.replaceCharacterJapan(json['text_b'] ?? ''),
      titleFront: ReplaceText.replaceCharacterJapan(json['title_f'] ?? ''),
      titleBack: ReplaceText.replaceCharacterJapan(json['title_b'] ?? ''),
      imageFront: json['image_f'] ?? "",
      imageBack: json['image_b'] ?? "",
      soundFront: json['sound_f'] ?? "",
      columnBack: ReplaceText.replaceCharacterJapan(json['col_b'] ?? ''),
      soundBack: json['sound_b'] ?? "");

  List<String> get listTextFront {
    var list = textFront.split('\n');
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  List<String> get listBackFront {
    var list = textBack.split('\n');
    list.removeWhere((element) => element.isEmpty);
    return list;
  }
}

class FlashCardModelListening extends FlashCardModel {
  final Sentences sentence;
  final Lesson lesson;
  FlashCardModelListening(
      {required super.id,
        required super.lessonId,
        required super.skillId,
        required super.titleFront,
        required super.titleBack,
        required super.textFront,
        required super.textBack,
        required super.imageFront,
        required super.imageBack,
        required super.soundFront,
        required super.soundBack,
        required super.columnBack,
        required this.lesson,
        required this.sentence});
}
class FlashCardModelReading extends FlashCardModel {
  final Sentence sentence;

  FlashCardModelReading(
      {required super.id,
        required super.lessonId,
        required super.skillId,
        required super.titleFront,
        required super.titleBack,
        required super.textFront,
        required super.textBack,
        required super.imageFront,
        required super.imageBack,
        required super.soundFront,
        required super.soundBack,
        required super.columnBack,
        required this.sentence});
}
class FlashCardModelSpeaking extends FlashCardModel {
  final SpeakingModel speaking;

  FlashCardModelSpeaking(
      {required super.id,
        required super.lessonId,
        required super.skillId,
        required super.titleFront,
        required super.titleBack,
        required super.textFront,
        required super.textBack,
        required super.imageFront,
        required super.imageBack,
        required super.soundFront,
        required super.soundBack,
        required super.columnBack,
        required this.speaking});
}
