import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final int courseId, lessonId, order;
  final String title, description;
  final bool enable, isCustom;
  final List<dynamic> customLessonsInfo, skills;
  LessonModel(
      {required this.courseId,
      required this.lessonId,
      required this.title,
      required this.description,
      required this.order,
      required this.customLessonsInfo,
      required this.skills,
      required this.enable,
      required this.isCustom});

  factory LessonModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LessonModel(
        lessonId: data['id'] ?? 0,
        courseId: data['course_id'] ?? 0,
        description: data['description'] ?? "",
        title: data['title'] ?? "",
        order: data['order'] ?? 0,
        enable: data['enable'] ?? true,
        isCustom: false,
        skills: data['skills'] ?? [],
        customLessonsInfo: []);
  }

  factory LessonModel.fromMap(Map<String, dynamic> data) {
    return LessonModel(
        lessonId: data['id'] ?? 0,
        courseId: data['course_id'] ?? 0,
        description: data['description'] ?? "",
        title: data['title'] ?? "",
        order: data['order'] ?? 0,
        enable: data['enable'] ?? true,
        isCustom: false,
        skills: data['skills'] ?? [],
        customLessonsInfo: []);
  }
  static Map<String, dynamic> toMap(LessonModel lessonModel) => {
        'course_id': lessonModel.courseId,
        'id': lessonModel.lessonId,
        'title': lessonModel.title,
        'description': lessonModel.description,
        'order': lessonModel.order,
        'enable': lessonModel.enable,
        'customLessonsInfo': lessonModel.customLessonsInfo,
        'is_custom' : lessonModel.isCustom,
        'skills' : lessonModel.skills,
      };

  static String encode(List<LessonModel> listLessons) => json.encode(
        listLessons
            .map<Map<String, dynamic>>(
                (lessonModel) => LessonModel.toMap(lessonModel))
            .toList(),
      );

  static List<LessonModel> decode(String listLesson) =>
      (json.decode(listLesson) as List<dynamic>)
          .map<LessonModel>((item) => LessonModel.fromMap(item))
          .toList();
}
