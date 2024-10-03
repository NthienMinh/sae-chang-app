import 'package:cloud_firestore/cloud_firestore.dart';

class LessonResultModel {
  final int id, lessonId, classId, teacherId, dateTime;
  final String status,
      teacherNoteForClass,
      teacherNoteForNextTeacher,
      teacherNoteForSupport,
      supportNoteForTeacher;

  LessonResultModel(
      {required this.id,
      required this.lessonId,
      required this.classId,
      required this.teacherId,
      required this.dateTime,
      required this.status,
      required this.teacherNoteForClass,
      required this.teacherNoteForNextTeacher,
      required this.teacherNoteForSupport,
      required this.supportNoteForTeacher});

  factory LessonResultModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LessonResultModel(
        id: data['id'],
        lessonId: data['lesson_id'],
        classId: data['class_id'],
        teacherId: data['teacher_id'],
        dateTime: data['date_time'] ?? 0,
        status: data['status'],
        teacherNoteForNextTeacher: data['teacher_note_for_next_teacher'] ?? '',
        teacherNoteForClass: data['teacher_note_for_class'] ?? '',
        teacherNoteForSupport: data['teacher_note_for_support'] ?? '',
        supportNoteForTeacher: data['support_note_for_teacher'] ?? '');
  }

  factory LessonResultModel.fromMap(Map<String, dynamic> data) {
    return LessonResultModel(
        id: data['id'],
        lessonId: data['lesson_id'],
        classId: data['class_id'],
        teacherId: data['teacher_id'],
        dateTime: data['date_time'] ?? 0,
        status: data['status'],
        teacherNoteForNextTeacher: data['teacher_note_for_next_teacher'] ?? '',
        teacherNoteForClass: data['teacher_note_for_class'] ?? '',
        teacherNoteForSupport: data['teacher_note_for_support'] ?? '',
        supportNoteForTeacher: data['support_note_for_teacher'] ?? '');
  }

  static Map<String, dynamic> toMap(LessonResultModel lessonResultModel) => {
        'id': lessonResultModel.id,
        'lesson_id': lessonResultModel.lessonId,
        'class_id': lessonResultModel.classId,
        'date_time': lessonResultModel.dateTime,
        'teacher_id': lessonResultModel.teacherId,
        'status': lessonResultModel.status,
        'teacher_note_for_next_teacher':
            lessonResultModel.teacherNoteForNextTeacher,
        'teacher_note_for_class': lessonResultModel.teacherNoteForClass,
        'teacher_note_for_support': lessonResultModel.teacherNoteForSupport,
        'support_note_for_teacher': lessonResultModel.supportNoteForTeacher
      };
}
