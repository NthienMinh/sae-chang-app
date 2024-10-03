import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/prefKeys_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/home/user_class_cubit.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/course_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/lesson_result_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/models/base_model/student_lesson_model.dart';
import 'package:sae_chang/models/base_model/student_test_model.dart';
import 'package:sae_chang/models/base_model/test_model.dart';
import 'package:sae_chang/models/base_model/test_result_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/models/base_model/user_model.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/shared_preferences.dart';
import 'package:sae_chang/untils/custom_toast.dart';
import 'package:sae_chang/untils/dialogs.dart';

import 'firebase_auth.dart';
import 'firestore_db.dart';

class FireBaseProvider {
  FireBaseProvider._privateConstructor();

  static final FireBaseProvider _instance =
      FireBaseProvider._privateConstructor();

  static FireBaseProvider get instance => _instance;

  Future<void> logOutUser(BuildContext context) async {
    await FirebaseAuthentication.instance.logOutUser();
    BaseSharedPreferences.setIntValue(PrefKeyConfigs.userId, -1);
    BaseSharedPreferences.setString(PrefKeyConfigs.email, '');
    BaseSharedPreferences.setString(PrefKeyConfigs.role, '');
    BaseSharedPreferences.setString(PrefKeyConfigs.logoutYet, 'true');
    BaseSharedPreferences.setString(PrefKeyConfigs.currentLevel, '');
    await UserClassCubit.instance.clearData();
    await CacheDataProvider.clearAllKey();
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        Routes.login, (route) => false,
      );
      // Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      //   Routes.chooseLevel,
      //   (route) => false,
      // );
      CustomToast.showBottomToast(context, 'Bạn đã đăng xuất');
    }
  }

  Future<String> login(
      String email, String password, BuildContext context) async {
    if (!context.read<ConnectCubit>().state) {
      Dialogs.showDialogLogin(
          context, 'Kết nối của bạn không ổn định', Colors.red, true);
      return '';
    }
    Dialogs.showLoadingDialog(context);
    final res =
        await FirebaseAuthentication.instance.logInUser(email, password);

    debugPrint('login state: $res');
    if (res == "true") {
      try {
        UserModel user = await getUserByEmail(email);
        await FirebaseAuthentication.instance.saveLogin(user);

        if (context.mounted) {
          Navigator.of(context).pop();
        }

        if(user.roles.contains("teacher")){
          BaseSharedPreferences.setString(PrefKeyConfigs.role, 'teacher');
        }else{
          BaseSharedPreferences.setString(PrefKeyConfigs.role, 'student');
        }

        if (user.roles.contains("student") || user.roles.contains("teacher")) {
          if(context.mounted){
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                Routes.home, (route) => false,
                arguments: {"level": AppText.txtHanNguSaeChang.text});
            CustomToast.showBottomToast(
                context, AppText.txtLoginSuccess.text.toLowerCase());
          }
        } else {
          FirebaseAuth.instance.signOut().then((value) {
            CustomToast.showBottomToast(context, AppText.txtNotAccess.text);
          });
        }
      } catch (e) {
        return "invalid-email-firestore";
      }
    } else {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
    return res;
  }

  Future<UserModel> getUserByEmail(String email) async {
    return (await FireStoreDb.instance.getUserByEmail(email))
        .docs
        .map((e) => UserModel.fromSnapshot(e))
        .single;
  }

  Future<List<UserClassModel>> getUserClass(int id) async {
    return (await FireStoreDb.instance.getUserClass(id))
        .docs
        .map((e) => UserClassModel.fromSnapshot(e))
        .toList();
  }

  Future<List<ClassModel>> getClassByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    if (ids.length <= 30) {
      return (await FireStoreDb.instance.getClassByIds(ids))
          .docs
          .map((e) => ClassModel.fromSnapshot(e))
          .where((element) => element.isSubClass == false)
          .toList();
    }
    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 30) {
      List<int> subList =
          ids.sublist(i, i + 30 > ids.length ? ids.length : i + 30);
      subLists.add(subList);
    }

    List<ClassModel> temp = [];

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getClassByIds(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    temp = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs
                  .map((e) => ClassModel.fromSnapshot(e))
                  .where((element) => element.isSubClass == false)
            ]);

    return temp;
  }

  Future<ClassModel> getClassById(id) async {
    return (await FireStoreDb.instance.getClassByClassId(id))
        .docs
        .map((e) => ClassModel.fromSnapshot(e))
        .single;
  }

  Future<TestModel> getTestById(id) async {
    return (await FireStoreDb.instance.getTestById(id))
        .docs
        .map((e) => TestModel.fromSnapshot(e))
        .single;
  }

  Future<LessonModel> getLessonById(id) async {
    return (await FireStoreDb.instance.getLessonById(id))
        .docs
        .map((e) => LessonModel.fromSnapshot(e))
        .single;
  }

  Future<List<CourseModel>> getCourseByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    if (ids.length <= 30) {
      return (await FireStoreDb.instance.getCourseByIds(ids))
          .docs
          .map((e) => CourseModel.fromSnapshot(e))
          .toList();
    }
    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 30) {
      List<int> subList =
          ids.sublist(i, i + 30 > ids.length ? ids.length : i + 30);
      subLists.add(subList);
    }

    List<CourseModel> temp = [];

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getCourseByIds(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    temp = responses.fold(
        [],
        (pre, res) =>
            [...pre, ...res.docs.map((e) => CourseModel.fromSnapshot(e))]);

    return temp;
  }

  Future<List<LessonModel>> getLessonsByCourseId(int id) async {
    return (await FireStoreDb.instance.getLessonsByCourseId(id))
        .docs
        .map((e) => LessonModel.fromSnapshot(e))
        .toList();
  }

  Future<List<TestModel>> getTestsByCourseId(int id) async {
    return (await FireStoreDb.instance.getTestsByCourseId(id))
        .docs
        .map((e) => TestModel.fromSnapshot(e))
        .toList();
  }

  Future<List<LessonResultModel>> getLessonResultsByClassId(int id) async {
    return (await FireStoreDb.instance.getLessonResultsByClassId(id))
        .docs
        .map((e) => LessonResultModel.fromSnapshot(e))
        .toList();
  }

  Future<List<TestResultModel>> getTestResultsByClassId(int id) async {
    return (await FireStoreDb.instance.getTestResultsByClassId(id))
        .docs
        .map((e) => TestResultModel.fromSnapshot(e))
        .toList();
  }

  Future<List<StudentLessonModel>> getStudentLessonsByClassId(
      int id, int userId) async {
    return (await FireStoreDb.instance.getStudentLessonsByClassId(id, userId))
        .docs
        .map((e) => StudentLessonModel.fromSnapshot(e))
        .toList();
  }

  Future<List<StudentTestModel>> getStudentTestsByClassId(
      int id, int userId) async {
    return (await FireStoreDb.instance.getStudentTestsByClassId(id, userId))
        .docs
        .map((e) => StudentTestModel.fromSnapshot(e))
        .toList();
  }

  List<LessonModel> getCustomLessons(List<dynamic> customLessons) {
    if (customLessons.isEmpty) {
      return [];
    }
    return customLessons.map((e) {
      return LessonModel(
          courseId: 0,
          lessonId: e['custom_lesson_id'] ?? 0,
          title: e['title'] ?? '',
          description: e['description'] ?? '',
          customLessonsInfo: e['lessons_info'] ?? [],
          order: 0,
          skills: [],
          enable: true,
          isCustom: true);
    }).toList();
  }

  Future<List<TestModel>> getCustomTests(List<dynamic> list) async {
    List<Future<TestModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getTestById(item['test_id']));
    }
    List<TestModel> items = await Future.wait(futures);
    var listCustomTest = [...list];

    items = items.map((e) {
      var temp = listCustomTest.first;
      listCustomTest.removeAt(0);
      return e.copyWith(
          id: temp['custom_test_id'], childTestId: temp['test_id']);
    }).toList();
    return items;
  }

  Future<StudentTestModel?> getTestState(
      int testId, int resultId, int studentId, int classId) async {
    final data = (await FireStoreDb.instance
            .getTestState(testId, resultId, studentId, classId))
        .docs
        .singleOrNull;
    return data == null ? null : StudentTestModel.fromSnapshot(data);
  }

  Future<void> createStudentTest(
      int time, int testId, int resultId, int userId, int classId) async {
    await FireStoreDb.instance
        .createStudentTest(time, testId, resultId, userId, classId);
  }

  Future<void> updateTestState(int time, Map<String, dynamic> map) async {
    return await FireStoreDb.instance
        .updateTestState(time, map);
  }

  Future<StudentLessonModel?> getLessonState(
      int lessonId, int resultId, int studentId, int classId) async {
    final data = (await FireStoreDb.instance
            .getLessonState(lessonId, resultId, studentId, classId))
        .docs
        .singleOrNull;
    return data == null ? null : StudentLessonModel.fromSnapshot(data);
  }

  Future<void> createStudentLesson(
      int time, int lessonId, int resultId, int userId, int classId) async {
    await FireStoreDb.instance
        .createStudentLesson(time, lessonId, resultId, userId, classId);
  }

  Future<void> updateLessonState(int time, Map<String, dynamic> map) async {
    return await FireStoreDb.instance
        .updateLessonState(time, map);
  }

  Future<List<AnswerModel>> getAnswer(int id, int userId, int dataId, int resultId,
      String type, int classId, List<QuestionModel> listQuestions) async {

    final listIdQuestion = listQuestions.map((e) {
      return e.id;
    }).toList();
    final snapshot = await FireStoreDb.instance.getAnswer(
        id, userId, type, classId, resultId, dataId);
    final questions = snapshot.docs
        .map((e) {
      return AnswerModel.fromSnapshot(e);
    })
        .where((element) => listIdQuestion.contains(element.questionId))
        .toList();

    return questions;
  }
}
