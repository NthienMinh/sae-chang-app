import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLessonModel {
  final int id, lessonResultId, lessonId, classId, userId, timeKeeping;
  final String teacherNoteForStudent, teacherNoteForSupport;
  final Map time, skills;

  StudentLessonModel(
      {required this.id,
      required this.lessonId,
      required this.teacherNoteForStudent,
      required this.timeKeeping,
      required this.time,
      required this.classId,
      required this.skills,
      required this.userId,
      required this.lessonResultId,
      required this.teacherNoteForSupport});

  factory StudentLessonModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentLessonModel(
      id: data['id'],
      lessonId: data['lesson_id'],
      lessonResultId: data['lesson_result_id'],
      classId: data['class_id'],
      userId: data['user_id'] ?? -1,
      timeKeeping: data['time_keeping'] ?? 0,
      teacherNoteForStudent: data['teacher_note_for_student'] ?? '',
      teacherNoteForSupport: data['teacher_note_for_support'] ?? '',
      time: data['time'] ?? {},
      skills: data['skills'] == null || data['skills'] == {}
          ? {'hw': -2, 'hws': []}
          : data['skills'],
    );
  }

  factory StudentLessonModel.fromMap(Map<String, dynamic> data) {
    return StudentLessonModel(
      id: data['id'],
      lessonId: data['lesson_id'],
      lessonResultId: data['lesson_result_id'],
      classId: data['class_id'],
      userId: data['user_id'] ?? -1,
      timeKeeping: data['time_keeping'] ?? -2,
      teacherNoteForStudent: data['teacher_note_for_student'] ?? '',
      teacherNoteForSupport: data['teacher_note_for_support'] ?? '',
      time: data['time'] ?? {},
      skills: data['skills'] ?? {},
    );
  }
}
