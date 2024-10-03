import 'dart:io';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';

import 'item_learn_model.dart';

class Lesson {
  final String mean;
  final List<Sentences> sentences;
  final List<QuestionReading> questions;
  final int id;
  final String title;
  final int lessonId;
  bool isLoading = false;
  final String? _pathAudio;
  final String? _dir;

  final String keyPrefix;



  Lesson(
      {required this.mean,
      required this.sentences,
      required this.questions,
      required this.id,
      required this.title,
      required this.lessonId,
      pathAudio,
      dir,
      this.keyPrefix = '',
      isLoading = false})
      : _dir = dir,
        _pathAudio = pathAudio;

  String get pathAudio {
    if(_pathAudio != null) {
      if(Platform.isAndroid){
        return _pathAudio;
      }
      else {
        return Functions.convertDirectory(_pathAudio);
      }
    }
    return '';
  }
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

  ItemLearnSkill  get itemLearn => ItemLearnSkill(id, title, mean, pathAudio: pathAudio);

  Lesson copyWith(
      {String? mean,
      List<Sentences>? sentences,
      List<QuestionReading>? questions,
      int? id,
      String? title,
      int? lessonId,
      String? pathAudio,
      String? dir,
      bool? isLoading}) {
    return Lesson(
        mean: mean ?? this.mean,
        sentences: sentences ?? this.sentences,
        questions: questions ?? this.questions,
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        title: title ?? this.title,
        pathAudio: pathAudio ?? this.pathAudio,
        dir: dir ?? this.dir,
        isLoading: isLoading ?? this.isLoading);
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
        mean: json['mean'] ?? '',
        sentences: json["sentences"] == null
            ? []
            : List<Sentences>.from(
                json["sentences"].map((x) => Sentences.fromJson(x))),
        questions: json["questions"] == null
            ? []
            : List<QuestionReading>.from(
                json["questions"].map((x) => QuestionReading.fromJsonV2(x))),
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        lessonId: json['lesson_id'] ?? 0);
  }

  factory Lesson.fromJsonV2(Map<String, dynamic> json, List<Sentences> list,
      List<QuestionReading> list1) {
    return Lesson(
      mean: json['mean'] ?? json['vi'] ?? '',
      sentences: list,
      questions: list1,
      id: json['id'] == null ? 0 : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      lessonId: json['lesson_id'] == null
          ? 0
          : int.parse(json['lesson_id'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mean'] = mean;
    data['sentences'] = sentences.map((v) => v.toJson()).toList();
    data['id'] = id;
    data['title'] = title;
    data['lesson_id'] = lessonId;
    return data;
  }

  bool? _isClick;

  bool get isClick => _isClick ?? false;

  set isClick(bool value) {
    _isClick = value;
  }

  bool? _isHighlight;

  bool get isHighlight => _isHighlight ?? false;

  set isHighlight(bool value) {
    _isHighlight = value;
  }


}
