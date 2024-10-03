import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sae_chang/configs/text_configs.dart';


class AnswerModel {
  final int userId,
      questionId,
      questionType,
      parentId,
      classId,
      resultId,
      dataId;
  final String teacherNote, type;
  final List answer, images, records, answerState;
  final double score;
  AnswerModel(
      {required this.userId,
      required this.questionId,
      required this.answer,
      required this.answerState,
      required this.score,
      required this.questionType,
      required this.parentId,
      required this.teacherNote,
      required this.type,
      required this.images,
      required this.records,
      required this.resultId,
      required this.dataId,
      required this.classId});

  List<String> get convertAnswer => convert(answer, questionType);
  List<String> convert(List answerList, int questionType) {
    List<String> listCv = [];
    if (questionType == 1 ||
        questionType == 5 ||
        questionType == 6 ||
        questionType == 11 ||
        questionType == 4) {
      if (answerList.isNotEmpty) {
        listCv = [answerList.first];
      } else {
        listCv = [AppText.txtIgnoreQuestion.text];
      }
    } else if (questionType == 3 || questionType == 10 || questionType == 2) {
      if (answerList.isNotEmpty) {
        listCv = [answerList.first];
      } else {
        for (var i in answerList) {
          listCv.add(i);
        }
      }
    } else if (questionType == 7) {
      String joinedString = answerList.join(' ');
      listCv = [joinedString];
    } else if (questionType == 8) {
      for (var i in answerList) {
        listCv.add(i.toString().replaceAll("|", "-"));
      }
      String joinedString = listCv.join('\n');
      listCv = [joinedString];
    }
    return listCv;
  }

  factory AnswerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AnswerModel(
        userId: data['user_id'] ?? 0,
        questionId: data['question_id'] ?? 0,
        score:
            data['score'] == null ? 0 : double.parse(data['score'].toString()),
        parentId: data['parent_id'] ?? 0,
        questionType: data['question_type'] ?? 0,
        teacherNote: data['teacher_note'] ?? '',
        type: data['type'] ?? '',
        classId: data['class_id'] ?? 0,
        images: data['teacher_images_note'] ?? [],
        records: data['teacher_records_note'] ?? [],
        answer: data['answer'] ?? [],
        answerState: data['answerState'] ?? [],
        resultId: data['result_id'] ?? 0,
        dataId: data['data_id'] ?? 0);
  }
  factory AnswerModel.fromJson(Map<String, dynamic> data) {
    return AnswerModel(
        userId: data['user_id'] ?? 0,
        questionId: data['question_id'] ?? 0,
        score:
            data['score'] == null ? 0 : double.parse(data['score'].toString()),
        parentId: data['parent_id'] ?? 0,
        questionType: data['question_type'] ?? 0,
        teacherNote: data['teacher_note'] ?? '',
        type: data['type'] ?? '',
        classId: data['class_id'] ?? 0,
        images: data['teacher_images_note'] ?? [],
        records: data['teacher_records_note'] ?? [],
        answer: data['answer'] ?? [],
        answerState: data['answerState'] ?? [],
        resultId: data['result_id'] ?? 0,
        dataId: data['data_id'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'question_id': questionId,
      'score': score,
      'answer': answer,
      'parent_id': parentId,
      'question_type': questionType,
      'teacher_note': "",
      'type': type,
      'class_id': classId,
      'teacher_images_note': images,
      'teacher_records_note': records,
      'answerState': answerState,
      'result_id': resultId,
      'data_id': dataId,
    };
  }
}
