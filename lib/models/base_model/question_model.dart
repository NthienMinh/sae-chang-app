import 'dart:async';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sae_chang/models/skill_models/speaking.dart';

class QuestionModel {
  final int id, lessonId, questionType, owner, skill, testId, difficulty, part;
  final String a,
      b,
      c,
      d,
      answer,
      question,
      explain,
      refer,
      instruction,
      paragraph;
  final String image, sound, video;
  final bool isHwDefault, isTestDefault;
  List<String>? _answered;
  List<String>? _answerState;
  List<String>? _columA;
  List<String>? _columB;
  List<String> listUrl = [];
  Completer completer = Completer();

  QuestionModel(
      {required this.id,
      required this.testId,
      required this.difficulty,
      required this.lessonId,
      required this.a,
      required this.b,
      required this.c,
      required this.d,
      required this.answer,
      required this.question,
      required this.skill,
      required this.image,
      required this.sound,
      required this.questionType,
      required this.isHwDefault,
      required this.isTestDefault,
      required this.video,
      required this.explain,
      required this.owner,
      required this.refer,
      required this.instruction,
      required this.paragraph,
      required this.part});

  List<String> get listImage => image.split(";").toList();

  List<String> get listSound => sound.split(";").toList();

  List<String> get listVideo => video.split(";").toList();

  List<String> get listAnswer => [a, b, c, d];

  String get convertQuestion => convert(question, questionType);

  String convert(String question, int questionType) {
    String convertedQuestion = "";
    if (questionType == 7) {
      convertedQuestion = question.replaceAll("/", " ");
    } else if (questionType == 8) {
      convertedQuestion = question.replaceAll(";", "\n").replaceAll("|", "-");
    } else if (questionType == 10) {
      convertedQuestion = "";
    } else {
      convertedQuestion = question;
    }
    return convertedQuestion;
  }

  List<String> get answered => _answered ?? [];

  set answered(List<String> values) {
    _answered = values;
  }

  Future<void> checkAndRemoveFileNotExists() async {

    // Fluttertoast.showToast(msg: 'checkAndRemoveFileNotExists ${id}');

    try {
      for (String path in [..._answered ?? []]) {
        if (!(await (File(path).exists()))) {
          _answered?.remove(path);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  List<String> get answerState => _answerState ?? [];

  set answerState(List<String> values) {
    _answerState = values;
  }

  List<String> get columA => _columA ?? [];

  set columA(List<String> values) {
    _columA = values;
  }

  List<String> get columB => _columB ?? [];

  set columB(List<String> values) {
    _columB = values;
  }

  bool? isSelected(String text) => _answered == null
      ? null
      : answerState[answerState.indexOf(_answered!.first)] == text;

  factory QuestionModel.fromMap(Map<String, dynamic> json) => QuestionModel(
      id: json['id'],
      lessonId: json['lesson_id'] ?? 0,
      testId: json['test_id'] ?? 0,
      a: json['a'] ?? "",
      b: json['b'] ?? "",
      c: json['c'] ?? "",
      d: json['d'] ?? "",
      answer: json['answer'] == null ? "" :  json['answer'].toString(),
      difficulty: int.tryParse(json['difficulty'].toString()) ?? 0,
      question: json['question'] ?? "",
      skill: json['skill_id'] ?? 0,
      image: json['image'] ?? "",
      sound: json['sound'] ?? "",
      video: json['video'] ?? "",
      questionType: json['question_type'] ?? 0,
      refer: json['refer'] ?? "",
      explain: json['explain'] ?? "",
      isTestDefault: json['is_hw_default'] == null || json['is_hw_default'].toString().isEmpty ? false : json['is_hw_default'],
      isHwDefault: json['is_test_default'] == null || json['is_test_default'].toString().isEmpty ? false : json['is_test_default'],
      owner: json['owner']  == null ||  json['owner'].toString().isEmpty ? 0 : json['owner'],
      instruction: json['instruction'] ?? "",
      paragraph: json['paragraph'] ?? "",
      part: int.tryParse(json['part'].toString()) ?? 0);


  factory QuestionModel.fromMap1(Map<String, dynamic> json) => QuestionModel(
      id: json['id'],
      lessonId: json['lesson_id'] ?? 0,
      testId: json['test_id'] ?? 0,
      a: json['a'] ?? "",
      b: json['b'] ?? "",
      c: json['c'] ?? "",
      d: json['d'] ?? "",
      answer: json['answer'] == null ? "" :  json['answer'].toString(),
      difficulty: int.tryParse(json['difficulty'].toString()) ?? 0,
      question: json['question'] ?? "",
      skill: json['skill_id'] ?? 0,
      image: json['image'] ?? "",
      sound: json['sound'] ?? "",
      video: json['video'] ?? "",
      questionType: int.tryParse(json['question_type'].toString()) ?? 0,
      refer: json['refer'] ?? "",
      explain: json['explain'] ?? "",
      isTestDefault: json['is_hw_default'] == null || json['is_hw_default'].toString().isEmpty ? false : json['is_hw_default'],
      isHwDefault: json['is_test_default'] == null || json['is_test_default'].toString().isEmpty ? false : json['is_test_default'],
      owner: json['owner']  == null ||  json['owner'].toString().isEmpty ? 0 : json['owner'],
      instruction: json['instruction'] ?? "",
      paragraph: json['paragraph'] ?? "",
      part: int.tryParse(json['part'].toString()) ?? 0);


  SpeakingModel get speakingModel {
    var listHide = <String>[];
    var ans = answer;
    if(answer.contains(';')) {
      var list = answer.split(';');
      ans = list[0];
      list.removeAt(0);
      listHide = list;
    }
    return SpeakingModel(
        id: id,
        lessonId: lessonId,
        type: 1,
        audio: sound,
        image: image,
        sentence: question,
        text: ans,
        vi: paragraph,
        hide: '',
        highlight: listHide.join(';'));
  }
}
