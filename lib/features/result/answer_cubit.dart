import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/prefKeys_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/course_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/models/base_model/test_model.dart';
import 'package:sae_chang/providers/download/btvn_provider.dart';
import 'package:sae_chang/providers/download/test_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/services/download_controller.dart';
import 'package:sae_chang/shared_preferences.dart';

class AnswerCubit extends Cubit<List<AnswerModel>?> {
  AnswerCubit(BuildContext context, int id, int userId, int classId,
      String type, bool isOffline, int dataId, int resultId)
      : super(null) {
    if (type == "DacNhan") {
      //loadAnswerTestSKM247(testId, lessonId);
    } else {
      load(context, id, userId, classId, type, isOffline, dataId, resultId);
    }
  }

  int userId = 0;
  int classId = 0;
  int id = 0;
  int dataId = 0;
  int resultId = 0;
  String dir = "";
  String role = 'student';

  List<QuestionModel> listQuestions = [];

  load(BuildContext context, int id, int userId, int classId, String type,
      bool isOffline, int dataId, int resultId) async {
    role = await BaseSharedPreferences.getString(PrefKeyConfigs.role);
    this.classId = classId;
    this.userId = userId;
    this.dataId = dataId;
    this.id = id;
    this.resultId = resultId;
    var courseId = 0;
    if (type == "test") {
      TestModel test = await FireBaseProvider.instance.getTestById(dataId);
      courseId = test.courseId;
    } else {
      LessonModel lesson = await FireBaseProvider.instance.getLessonById(id);
      courseId = lesson.courseId;
    }

    CourseModel course =
        (await FireBaseProvider.instance.getCourseByIds([courseId])).first;

    String token = course.dataToken;
    String dir = await DownLoadController.getDownloadFolder(
        dataId, type == "test" ? "test" : "btvn", course.dataVersion);

    this.dir = dir;

    List<QuestionModel> data = [];
    if (context.mounted) {
      if (type == "test") {
        if (context.mounted) {
          await TestProvider.instance
              .downloadFile(context, id, token, dataId, course.dataVersion);
          data = await TestProvider.instance.getTests(dir);
        }
      } else {
        if (context.mounted) {
          await BtvnProvider.instance
              .downloadFile(context, dataId, token, course.dataVersion);
          data = await BtvnProvider.instance.getBtvns(dir);
        }
      }
    }
    listQuestions = data;

    debugPrint('=>>>>>>>>${listQuestions.length}');
    var listAns = <AnswerModel>[];
    if (!isOffline) {
      listAns = await FireBaseProvider.instance.getAnswer(
          id, userId, dataId, resultId, type, classId, listQuestions);
    } else {
      var key =
          await BaseSharedPreferences.getKey(type, id, resultId, 'answer');

      var list = await SharePreferencesListProvider.instance.getList(key);

      listAns = list.map((e) {
        final json = jsonDecode(e);
        return AnswerModel.fromJson(json);
      }).toList();
    }

    if (isClosed) return;
    emit(listAns);
  }

  loadAnswerTestSKM247(int testId, int dateAnswer) async {
    // xem lessonId là dateTime id test sakumi247
    //
    // var dir =
    //     '${await CourseService.instance.createPrefix()}test_general/';
    // AppConfigs.dir = await DownLoadController.createDirectory(dir);
    //
    // var listAnswer = await DriftDbProvider.db.database
    //     .getAnswerSakumi247ByDateAndTestId(dateAnswer, testId);
    //
    // listQuestions = await Sakumi247Repository.getQuestionsByListId(
    //     listAnswer.map((e) => e.questionId).toList());
    //
    // emit(listAnswer.map((e) {
    //   var answer = <String>[];
    //   if (e.answer.isNotEmpty) {
    //     answer =
    //         (jsonDecode(e.answer) as List).map((e) => e.toString()).toList();
    //   }
    //   var answerState = <String>[];
    //   if (e.answerState.isNotEmpty) {
    //     answerState = (jsonDecode(e.answerState) as List)
    //         .map((e) => e.toString())
    //         .toList();
    //   }
    //   return AnswerModel(
    //       questionId: e.questionId,
    //       answer: answer,
    //       answerState: answerState,
    //       score: double.parse(e.score),
    //       questionType: e.questionType,
    //       parentId: e.parentId,
    //       teacherNote: '',
    //       type: e.type,
    //       images: [],
    //       records: [], userId: null, resultId: null, dataId: null, classId: null);
    // }).toList());
  }
}
