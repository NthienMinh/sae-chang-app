import 'package:sae_chang/models/base_model/question_model.dart';

import 'flash_card_model.dart';
import 'item_learn_model.dart';
import 'lesson.dart';

class Sentences {
  final String sentence;
  final String character;
  final String furigana;
  final String phonetic;
  final String mean;
  final int start;
  final int end;
  final int id;
  final int listeningLessonId;
  bool isHighLight;

  Sentences(
      {required this.sentence,
      required this.character,
      required this.furigana,
      required this.phonetic,
      required this.mean,
      required this.start,
      required this.end,
      required this.id,
      required this.listeningLessonId,
      this.isHighLight = false});

  Sentences copyWith(
      {String? sentence,
      String? character,
      String? furigana,
      String? phonetic,
      String? mean,
      int? start,
      int? end,
      int? id,
      int? listeningLessonId,
      bool? isHighLight}) {
    return Sentences(
        sentence: sentence ?? this.sentence,
        character: character ?? this.character,
        furigana: furigana ?? this.furigana,
        phonetic: phonetic ?? this.phonetic,
        mean: mean ?? this.mean,
        start: start ?? this.start,
        end: end ?? this.end,
        id: id ?? this.id,
        listeningLessonId: listeningLessonId ?? this.listeningLessonId,
        isHighLight: isHighLight ?? this.isHighLight);
  }

  factory Sentences.fromJson(Map<String, dynamic> json) {
    return Sentences(
        sentence: json['sentence'] ?? '',
        character: json['character'] ?? '',
        furigana: json['furigana'] ?? '',
        phonetic: json['phonetic'] ?? '',
        mean: json['mean'] ?? json['vi'] ??'',
        start: json['start'] ?? 0,
        end: json['end'] ?? 0,
        id: json['id'] ?? 0,
        listeningLessonId: json['listening_lesson_id'] ?? 0);
  }

  factory Sentences.fromJsonV2(Map<String, dynamic> json) {
    return Sentences(
        sentence: json['sentence'] ?? '',
        character: json['character'] ?? '',
        furigana: json['furigana'] ?? '',
        phonetic: json['phonetic'] ?? '',
        mean: json['mean'] ??json['vi'] ?? '',
        start:  int.tryParse(json['start'].toString()) ?? 0,
        end: int.tryParse(json['end'].toString()) ?? 0,
        id: int.tryParse(json['id'].toString()) ?? 0,
      listeningLessonId: int.tryParse(json['listening_lesson_id'].toString()) ?? 0,);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sentence'] = sentence;
    data['character'] = character;
    data['furigana'] = furigana;
    data['phonetic'] = phonetic;
    data['mean'] = mean;
    data['start'] = start;
    data['end'] = end;
    data['id'] = id;
    data['listening_lesson_id'] = listeningLessonId;
    return data;
  }
  QuestionModel get questionModel => QuestionModel(
      id: id,
      testId: 0,
      difficulty: 0,
      lessonId: 0,
      a: '',
      b: '',
      c: '',
      d: '',
      answer: convertItem(sentence),
      question: '{$sentence}',
      skill: 0,
      image: '',
      sound: '',
      questionType: 22,
      isHwDefault: false,
      isTestDefault: false,
      video: '',
      explain: '',
      owner: 0,
      refer: '',
      instruction: '',
      paragraph: mean,
      part: 0);

  FlashCardModelListening  listeningFlashcard(Lesson lesson) => FlashCardModelListening(
      id: id,
      lessonId: 0,
      skillId: 6,
      titleFront: '',
      titleBack: '',
      textFront: '',
      textBack: '',
      imageFront: '',
      imageBack: '',
      soundFront: '',
      soundBack: '',
      columnBack: '',
      lesson: lesson,
      sentence: this);

  ItemLearnSentenceListening itemLearn(Lesson parentItem) {
    return ItemLearnSentenceListening(id, this, parentItem);
  }

  String convertItem(String sentence) {
    var temp = sentence.split('');
    return temp.map((e)=> '{$e}').join('');
  }



}
