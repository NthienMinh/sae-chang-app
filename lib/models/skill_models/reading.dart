import 'dart:io';
import 'package:sae_chang/features/function/functions.dart';

import 'flash_card_model.dart';
import 'item_learn_model.dart';


class Reading {
  final int id;
  final String title;
  final int lessonId;
  final String mean;
  final List<Sentence> sentences;
  final List<QuestionReading> questions;
  final String? _dir;
  final int userId;
  final String keyPrefix;
  Reading({
    required this.id,
    required this.title,
    required this.lessonId,
    required this.mean,
    required this.sentences,
    required this.questions,
    dir,
    this.keyPrefix ='',
    this.userId = 0,
  }) : _dir = dir;


  String get dir {
    if(_dir != null) {
      if(Platform.isAndroid){
        return _dir;
      }
      else {
        return Functions.convertDirectory(_dir);
      }
    }
    return '';
  }
  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      id: json['id'],
      title: json['title'],
      lessonId: json['lesson_id'],
      mean: json['mean'],
      sentences: List<Sentence>.from(
        json['sentences'].map((sentence) => Sentence.fromJson(sentence)),
      ),
      questions: List<QuestionReading>.from(
        json['questions'].map((question) => QuestionReading.fromJson(question)),
      ),
    );
  }

  factory Reading.fromJsonV2(Map<String, dynamic> json, List<Sentence> list1, List<QuestionReading> list2) {
    return Reading(
      id: json['id'] == null ? 0 : int.parse(json['id'].toString()),
      title: json['title'],
      lessonId: json['lesson_id'] == null ? 0 : int.parse(json['lesson_id'].toString()),
      mean: json['mean'] ?? json['vi'] ??'',
      sentences: list1,
      questions: list2,
    );
  }

  bool? _isClick;
  bool get isClick => _isClick ?? false;

  ItemLearnSkill  get itemLearn => ItemLearnSkill(id,title, mean);

  set isClick(bool value) {
    _isClick = value;
  }

  bool? _isHighlight;
  bool get isHighlight => _isHighlight ?? false;

  set isHighlight(bool value) {
    _isHighlight = value;
  }
}

class Sentence {
  final String sentence;
  final int readingLessonId;
  final String furigana;
  final String mean;
  final int id;

  Sentence({
    required this.sentence,
    required this.readingLessonId,
    required this.furigana,
    required this.mean,
    required this.id,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      sentence: json['sentence'] ?? '',
      readingLessonId: json['reading_lesson_id']?? 0,
      furigana: json['furigana'] ?? '',
      mean: json['mean'] ??  json['vi'] ?? '',
      id: json['id'] ?? 0,
    );
  }
  factory Sentence.fromJsonV2(Map<String, dynamic> json) {
    return Sentence(
      sentence: json['sentence'] ?? '',
      readingLessonId: json['reading_lesson_id'] == null ? 0 : int.parse(json['reading_lesson_id']),
      furigana: json['furigana'] ?? '',
      mean: json['mean'] ??  json['vi'] ?? '',
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }
  bool? _isLearn;
  bool get isLearn => _isLearn ?? false;

  ItemLearnSentenceReading  itemLearn(Reading reading) => ItemLearnSentenceReading(
    id, this,reading
  );

  set isLearn(bool value) {
    _isLearn = value;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sentence'] = sentence;
    data['reading_lesson_id'] = readingLessonId;
    data['furigana'] = furigana;
    data['mean'] = mean;
    data['id'] = id;
    return data;
  }

  FlashCardModelReading get readingFlashcard => FlashCardModelReading(
      id: id,
      lessonId: 0,
      skillId: 7,
      titleFront: '',
      titleBack: '',
      textFront: '',
      textBack: '',
      imageFront: '',
      imageBack: '',
      soundFront: '',
      soundBack: '',
      columnBack: '',
      sentence: this);

}

class QuestionReading {
  final String explain;
  final int readingLessonId;
  final String a;
  final String b;
  final String c;
  final String d;
  final String question;
  final String answer;
  final int id;

  QuestionReading({
    required this.explain,
    required this.readingLessonId,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.question,
    required this.answer,
    required this.id,
  });

  factory QuestionReading.fromJson(Map<String, dynamic> json) {
    return QuestionReading(
      explain: json['explain'] ?? json['explain_vi'] ?? json['vi'] ?? '',
      readingLessonId: int.tryParse(json['reading_lesson_id'].toString()) ?? 0,
      a: json['a']?? '',
      b: json['b']?? '',
      c: json['c']?? '',
      d: json['d']?? '',
      question: json['question']?? '',
      answer: (json['answer'] ?? json['answer_vi']?? '').toString(),
      id: json['id']?? 0,
    );
  }

  factory QuestionReading.fromJsonV2(Map<String, dynamic> json) {
    return QuestionReading(
      explain: json['explain'] ?? json['explain_vi'] ?? json['vi'] ?? '',
      readingLessonId: int.tryParse(json['reading_lesson_id'].toString()) ?? int.tryParse(json['lesson_id'].toString()) ?? 0,
      a: json['a'] ?? '',
      b: json['b']?? '',
      c: json['c']?? '',
      d: json['d']?? '',
      question: json['question']?? '',
      answer:(json['answer'] ?? json['answer_vi'] ?? '').toString(),
      id:  int.tryParse(json['id'].toString()) ?? 0,
    );
  }


  factory QuestionReading.fromJsonGrammar(Map<String, dynamic> json) {
    return QuestionReading(
      explain: json['explain'] ?? json['explain_vi'] ?? json['vi'] ?? '',
      readingLessonId:  int.tryParse(json['grammar_id'].toString()) ?? 0,
      a: json['correct'] ?? '',
      b: json['incorrect_1']?? '',
      c: json['incorrect_2']?? '',
      d: json['incorrect_3']?? '',
      question: json['question']?? '',
      answer: '1',
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'explain': explain,
      'readingLessonId': readingLessonId,
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'question': question,
      'answer': answer,
      'id': id,
    };
  }
  String get answerTrue {
    if(answer == '1') {
      return a;
    }
    else if(answer == '2') {
      return b;
    }
    else if(answer == '3') {
      return c;
    }
    else {
      return d;
    }
  }
  List<String>? _answered;
  List<String>? _answerState;
  List<String> get answerState => _answerState ??  [];
  List<String> get answered => _answered ?? [];
  Map<int, String> maps = {};
  set answered(List<String> values) {
    _answered = values;
  }

  set answerState(List<String> values) {
    _answerState = values;
  }

  List<String>? _columA;
  List<String>? _columB;
  String? _soundPath;
  List<String> get columA => _columA ?? [];
  String get soundPath => _soundPath ?? '';
  set soundPath(String value) {
    _soundPath = value;
  }
  set columA(List<String> values) {
    _columA = values;
  }

  List<String> get columB => _columB ?? [];

  set columB(List<String> values) {
    _columB = values;
  }

  List<String> get listAnswer => [a, b, c, d];
}
