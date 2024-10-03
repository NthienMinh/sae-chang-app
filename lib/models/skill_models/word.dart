import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'flash_card_model.dart';


class Word {
  final String phonetic;
  final String mean;
  final String example_mean;
  final int id;
  final String type;
  final int lesson_id;
  final String word;
  final String example;
  final String? _pathAudio;
  final String? _dir;
  final String? _pathImage;
  bool isChoose = true;
  bool isHighlight;
  bool isMemorize;

  Word({
    required this.phonetic,
    required this.mean,
    required this.example_mean,
    required this.id,
    required this.type,
    required this.lesson_id,
    required this.word,
    required this.example,
    pathAudio,
    pathImage,
    dir,
    this.isHighlight = false,
    this.isMemorize = false
  }) : _pathAudio = pathAudio , _pathImage = pathImage , _dir = dir;


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

  String get pathImage {
    if(_pathImage != null) {
      if(Platform.isAndroid){
        return _pathImage;
      }
      else {
        return Functions.convertDirectory(_pathImage);
      }
    }
    debugPrint('object: oooo');
    return '';
  }


  Word copyWith({
    String? phonetic,
    String? mean,
    String? example_mean,
    int? id,
    String? type,
    int? lesson_id,
    String? word,
    String? example,
    String? pathAudio,
    String? pathImage,
    String? dir,
    bool? isHighlight,
    bool? isMemorize,
  }) {

    return Word(
      phonetic: phonetic ?? this.phonetic,
      mean: mean ?? this.mean,
      example_mean: example_mean ?? this.example_mean,
      id: id ?? this.id,
      type: type ?? this.type,
      lesson_id: lesson_id ?? this.lesson_id,
      word: word ?? this.word,
      example: example ?? this.example,
      pathAudio: pathAudio ?? this.pathAudio,
      pathImage: pathImage ?? this.pathImage,
      isHighlight: isHighlight ?? this.isHighlight,
      isMemorize: isMemorize ?? this.isMemorize,
      dir: dir,
    );
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      phonetic: json['phonetic'] ?? '',
      mean: json['mean'] ?? json['vi'] ?? '',
      example_mean: json['example_mean'] ?? json['example_vi'] ?? '',
      id: json['id'] ?? -1,
      type: json['type'] ?? '',
      lesson_id: json['lesson_id'] ?? -1,
      word: json['word'] ?? '',
      example: json['example'] ?? '',
    );
  }
  factory Word.fromJsonV2(Map<String, dynamic> json) {
    return Word(
      phonetic: json['phonetic'] ?? '',
      mean: json['mean'] ?? json['vi'] ?? '',
      example_mean: json['example_mean'] ?? json['example_vi'] ?? '',
      id: int.tryParse(json['id'].toString()) ?? -1,
      type: json['type'] ?? '',
      lesson_id: int.tryParse(json['lesson_id'].toString()) ?? -1,
      word: json['word'] ?? '',
      example: json['example'] ?? '',
    );
  }


  FlashCardModel get wordFlashcard {
    var flashCardModel =
    FlashCardModel(
        id: id,
        lessonId: lesson_id,
        skillId: 1,
        titleFront:   word.trim(),
        titleBack: mean,
        textFront: example,
        textBack: example_mean,
        imageFront: pathImage.isNotEmpty ? pathImage : '$id.png',
        imageBack: '',
        soundFront: pathAudio.isNotEmpty ?  pathAudio : "$id.mp3",
        soundBack: '',
        columnBack: '');
    return flashCardModel;
  }


  bool? _isClick;
  bool get isClick => _isClick ?? false;

  set isClick(bool value) {
    _isClick = value;
  }

  String get showWord => word;

}
