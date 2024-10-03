import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final int id, lessonCount, termId, dataVersion;
  final String code,
      level,
      description,
      type,
      termName,
      title,
      dataToken,
      downloadToken,
      prefix,
      suffix;

  CourseModel(
      {required this.id,
      required this.lessonCount,
      required this.title,
      required this.description,
      required this.termId,
      required this.level,
      required this.type,
      required this.dataVersion,
      required this.termName,
      required this.code,
      required this.dataToken,
      required this.suffix,
      required this.prefix,
      required this.downloadToken});
  factory CourseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CourseModel(
        lessonCount: data['lesson_count'] ?? 0,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        termId: data['term_id'] ?? -1,
        level: data['level'] ?? '',
        termName: data['term_name'] ?? '',
        type: data['type'] ?? '',
        id: data['id'] ?? -1,
        dataVersion: data['data_version'] ?? 0,
        code: data['code'] ?? '',
        dataToken: data['data_token'] ?? '_',
        suffix: data['suffix'] ?? '_',
        prefix: data['prefix'] ?? '_',
        downloadToken: data['download_token'] ?? '_');
  }

  factory CourseModel.fromMap(Map<String, dynamic> data) {
    return CourseModel(
        lessonCount: data['lesson_count'] ?? 0,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        termId: data['term_id'] ?? -1,
        level: data['level'] ?? '',
        termName: data['term_name'] ?? '',
        type: data['type'] ?? '',
        id: data['id'] ?? -1,
        dataVersion: data['data_version'] ?? 0,
        code: data['code'] ?? '',
        dataToken: data['data_token'] ?? '_',
        suffix: data['suffix'] ?? '_',
        prefix: data['prefix'] ?? '_',
        downloadToken: data['download_token'] ?? '_');
  }
  static Map<String, dynamic> toMap(CourseModel courseModel) => {
        'lesson_count': courseModel.lessonCount,
        'title': courseModel.title,
        'description': courseModel.description,
        'term_id': courseModel.termId,
        'level': courseModel.level,
        'term_name': courseModel.termName,
        'type': courseModel.type,
        'id': courseModel.id,
        'data_version': courseModel.dataVersion,
        'code': courseModel.code,
        'data_token': courseModel.dataToken,
        'suffix': courseModel.suffix,
        'prefix': courseModel.suffix,
        'download_token': courseModel.downloadToken
      };

  static String encode(List<CourseModel> listCourses) => json.encode(
        listCourses
            .map<Map<String, dynamic>>(
                (courseModel) => CourseModel.toMap(courseModel))
            .toList(),
      );

  static List<CourseModel> decode(String listCourses) =>
      (json.decode(listCourses) as List<dynamic>)
          .map<CourseModel>((item) => CourseModel.fromMap(item))
          .toList();
}
