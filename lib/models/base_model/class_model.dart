import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final int classId, courseId, start, end, subClassId;

  final String code, status, type, description, note, link;
  final List<dynamic> customLesson, customTest;
  final bool isSubClass;
  ClassModel(
      {required this.classId,
      required this.courseId,
      required this.start,
      required this.end,
      required this.subClassId,
      required this.code,
      required this.status,
      required this.type,
      required this.description,
      required this.note,
      required this.link,
      required this.isSubClass,
      required this.customTest,
      required this.customLesson});

  factory ClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ClassModel(
        classId: data['id'] ?? -1,
        courseId: data['course_id'] ?? -1,
        description: data['description'] ?? '',
        note: data['note'] ?? '',
        customLesson: data['custom_lessons'] ?? [],
        isSubClass: data['is_sub_class'] ?? false,
        start: data['start'] ?? -1,
        end: data['end'] ?? -1,
        subClassId: data['sub_class_id']??-1,
        code: data['code']??'',
        status: data['status'] ?? 'InProgress',
        type: data['type']?? 'Lớp chung',
        link: data['link']??'_',
        customTest: data['custom_tests']??[]);
  }

  factory ClassModel.fromMap(Map<String, dynamic> data) {
    return ClassModel(
        classId: data['id'] ?? -1,
        courseId: data['course_id'] ?? -1,
        description: data['description'] ?? '',
        note: data['note'] ?? '',
        customLesson: data['custom_lessons'] ?? [],
        isSubClass: data['is_sub_class'] ?? false,
        start: data['start'] ?? -1,
        end: data['end'] ?? -1,
        subClassId: data['sub_class_id']??-1,
        code: data['code']??'',
        status: data['status'] ?? 'InProgress',
        type: data['type']?? 'Lớp chung',
        link: data['link']??'_',
        customTest: data['custom_tests']??[]);
  }
}
