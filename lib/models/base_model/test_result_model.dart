import 'package:cloud_firestore/cloud_firestore.dart';

class TestResultModel {
  final int id, classId, testId, teacherId, courseId, dateAssign;
  final String status;

  const TestResultModel(
      {required this.id,
      required this.classId,
      required this.testId,
      required this.courseId,
      required this.teacherId,
      required this.dateAssign,
      required this.status});

  factory TestResultModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TestResultModel(
      classId: data["class_id"] ?? 0,
      testId: data["test_id"] ?? 0,
      courseId: data['course_id'] ?? 0,
      teacherId: data["teacher_id"] ?? 0,
      dateAssign: data['date_assign'] ?? 0,
      status: data['status'] ?? 'InProgress',
      id: data['id'] ?? -1,
    );
  }

  factory TestResultModel.fromMap(Map<String, dynamic> data) {
    return TestResultModel(
      classId: data["class_id"] ?? 0,
      testId: data["test_id"] ?? 0,
      courseId: data['course_id'] ?? 0,
      teacherId: data["teacher_id"] ?? 0,
      dateAssign: data['date_assign'] ?? 0,
      status: data['status'] ?? 'InProgress',
      id: data['id'] ?? -1,
    );
  }
}
