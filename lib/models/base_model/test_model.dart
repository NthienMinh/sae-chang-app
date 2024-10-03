import 'package:cloud_firestore/cloud_firestore.dart';

class TestModel {
  final String title, description;
  final int id, courseId, difficulty, duration, dataId;
  final bool enable, isCustom;

  const TestModel(
      {required this.id,
      required this.title,
      required this.difficulty,
      required this.courseId,
      required this.description,
      required this.enable,
      required this.duration,
      required this.isCustom,
      required this.dataId});

  TestModel copyWith(
      {int? id,
      int? childTestId}) {
    return TestModel(
      id: id ?? this.id,
      title: title ,
      difficulty: difficulty,
      courseId: courseId ,
      duration: duration ,
      description: description ,
      enable: true,
      isCustom: true,
      dataId: childTestId ?? this.dataId,
    );
  }

  factory TestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TestModel(
        id: data["id"],
        title: data["title"] ?? "",
        difficulty: data['difficulty'] ?? 0,
        courseId: data["course_id"] ?? 0,
        description: data['description'] ?? "",
        enable: data['enable'] ?? true,
        duration: data['duration'] ?? 0,
        isCustom: false,
        dataId: 0);
  }
}
