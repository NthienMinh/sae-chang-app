import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTestModel {
  final int id, testResultId, testId, classId, userId, time;
  final dynamic score;

  StudentTestModel(
      {required this.id,
        required this.testId,
        required this.score,
        required this.time,
        required this.classId,
        required this.userId,
        required this.testResultId});

  factory StudentTestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentTestModel(
        id: data['id'],
        testId: data['test_id'],
        score: data['score'],
        classId: data['class_id'],
        userId: data['user_id'],
        testResultId: data['test_result_id'] ,
        time: data['time'] ?? 0
    );
  }

  factory StudentTestModel.fromMap(Map<String, dynamic> data) {
    return StudentTestModel(
      id: data['id'],
      testId: data['test_id'],
      score: data['score'],
      classId: data['class_id'],
      userId: data['user_id'],
      testResultId: data['test_result_id'] ,
      time: data['time'] ?? 0
    );
  }
}
