import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';

class FireStoreDb {
  FireStoreDb._privateConstructor();

  static FireStoreDb instance = FireStoreDb._privateConstructor();
  FirebaseFirestore get db {
    return FirebaseFirestore.instanceFor(
        app: Firebase.app(), databaseId: "dacnham");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(
      String email) async {
    final snapshot =
        await db.collection("users").where('email', isEqualTo: email).get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getUserByEmail $email ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserClass(int id) async {
    final snapshot = await db
        .collection("user_class")
        .where('type', isEqualTo: 'student')
        .where('user_id', isEqualTo: id)
        .get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getUserClass with id $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassByClassId(
      int classId) async {
    final snapshot =
        await db.collection('class').where('id', isEqualTo: classId).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getClassByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTestById(int id) async {
    final snapshot =
        await db.collection('tests').where('id', isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTestById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonById(int id) async {
    final snapshot =
    await db.collection('lessons').where('id', isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassByIds(
      List<int> ids) async {
    final snapshot =
        await db.collection('class').where('id', whereIn: ids).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getClassByIds $ids ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourseByIds(
      List<int> ids) async {
    final snapshot =
        await db.collection('courses').where('id', whereIn: ids).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseByIds $ids ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByCourseId(
      int id) async {
    final snapshot =
        await db.collection('lessons').where('course_id', isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsByCourseId $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTestsByCourseId(int id) async {
    final snapshot =
        await db.collection('tests').where('course_id', isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTestsByCourseId $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultsByClassId(
      int classId) async {
    final snapshot = await db
        .collection('lesson_results')
        .where('class_id', isEqualTo: classId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonResultsByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTestResultsByClassId(
      int classId) async {
    final snapshot = await db
        .collection('test_results')
        .where('class_id', isEqualTo: classId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTestResultsByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentLessonsByClassId(
      int classId, int userId) async {
    final snapshot = await db
        .collection('student_lessons')
        .where('class_id', isEqualTo: classId)
        .where('user_id', isEqualTo: userId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentLessonsByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentTestsByClassId(
      int classId, int userId) async {
    final snapshot = await db
        .collection('student_tests')
        .where('class_id', isEqualTo: classId)
        .where('user_id', isEqualTo: userId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentTestsByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTestState(
      int testId, int resultId, int userId, int classId) async {
    final snapshot = await db
        .collection("student_tests")
        .where("test_id", isEqualTo: testId)
        .where("user_id", isEqualTo: userId)
        .where('class_id', isEqualTo: classId)
        .where('test_result_id', isEqualTo: resultId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTestState id: $testId result_id: $resultId user_id: $userId class_id: $classId ${snapshot.size}");

    return snapshot;
  }

  Future createStudentTest(
      int id, int testId, int resultId, int userId, int classId) async {
    CollectionReference create = db.collection('student_tests');
    create
        .doc('student_test_$id')
        .set({
          'id': id,
          'score': -2,
          'test_id': testId,
          'class_id': classId,
          'user_id': userId,
          'test_result_id': resultId,
          'time': 0,
          'skip': 0
        })
        .then((value) => debugPrint("student test Added"))
        .catchError((error) => debugPrint("Failed to add result: $error"));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonState(
      int lessonId, int resultId, int userId, int classId) async {
    final snapshot = await db
        .collection("student_lessons")
        .where("lesson_id", isEqualTo: lessonId)
        .where("user_id", isEqualTo: userId)
        .where('class_id', isEqualTo: classId)
        .where('lesson_result_id', isEqualTo: resultId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonState id: $lessonId result_id: $resultId user_id: $userId class_id: $classId ${snapshot.size}");

    return snapshot;
  }

  Future createStudentLesson(
      int id, int testId, int resultId, int userId, int classId) async {
    CollectionReference create = db.collection('student_lessons');
    create
        .doc('student_lesson_$id')
        .set({
          'id': id,
          'lesson_id': testId,
          'class_id': classId,
          'user_id': userId,
          'lesson_result_id': resultId,
          'time': {},
          'time_keeping': 0,
          'teacher_note_for_student': '',
          'teacher_note_for_support': '',
          'skills': {
            'hw': -2,
            'hws': []
          }
        })
        .then((value) => debugPrint("student lesson Added"))
        .catchError((error) => debugPrint("Failed to add result: $error"));
  }

  Future updateLessonState(int id, Map<String, dynamic> map) async {
    db
        .collection('student_lessons')
        .doc('student_lesson_$id')
        .update({'skills': map});
  }

  Future updateTestState(int id, Map<String, dynamic> map) async {
    db
        .collection('student_tests')
        .doc(
        'student_test_$id')
        .update(map);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAnswer(
      int parentId, int userId, String type, int classId, int resultId, int dataId) async {
    final snapshot = await db
        .collection("answers")
        .where("parent_id", isEqualTo: parentId)
        .where("user_id", isEqualTo: userId)
        .where("type", isEqualTo: type)
        .where("class_id", isEqualTo: classId)
        .where("result_id", isEqualTo: resultId)
        .where("data_id", isEqualTo: dataId)
        .get();

    debugPrint("FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAnswer ${snapshot.size}");

    return snapshot;
  }
}
