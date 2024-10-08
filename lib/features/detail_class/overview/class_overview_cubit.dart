import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/lesson_result_model.dart';
import 'package:sae_chang/models/base_model/student_lesson_model.dart';
import 'package:sae_chang/models/base_model/student_test_model.dart';
import 'package:sae_chang/models/base_model/test_result_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';

class ClassOverviewCubit extends Cubit<int> {
  ClassOverviewCubit(this.userClass) : super(0);

  final UserClassModel userClass;
  String level = "";
  double attendPercent = 0;
  double subClassPercent = 0;
  double homeworkPercent = 0;
  double avgScoreTest = 0;
  double avgScoreHomeWork = 0;
  int numLessonOpened = 0;
  int numAllLesson = 0;
  String titleElective = 'Đang tải khoá...';

  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;
  List<LessonModel>? lessons;
  List<LessonResultModel>? lessonResults;
  List<TestResultModel>? testResults;

  ClassModel? classModel;

  load() async {
    if (ConnectCubit.instance.state) {
      await CacheDataProvider.classById(userClass.classId, loadClass);
      await CacheDataProvider.lessonOfClass(classModel!.courseId,userClass.classId, classModel!.customLesson ,loadLesson);
      await CacheDataProvider.lessonResultsByClassId(userClass.classId, loadLessonResult);
      await CacheDataProvider.testResultsByClassId(userClass.classId, loadTestResult);
      await CacheDataProvider.studentLessonsByClassId(userClass.classId,userClass.userId, loadStudentLessons);
      await CacheDataProvider.studentTestsByClassId(userClass.classId,userClass.userId, loadStudentTests);

      numAllLesson = lessons!.length + classModel!.customLesson.length;
      numLessonOpened = lessonResults!.length;

      List<int> listLessonId = lessons!.map((e) => e.lessonId).toList();

      int attendCount = stdLessons!
          .where((i) => ![0, 5, 6].contains(i.timeKeeping))
          .length;
      int homeworkCount =
          stdLessons!.where((i) => i.skills['hw'] != -2 || i.skills['hws'].isNotEmpty).length;

      //homework avg score
      var listScore = <dynamic>[];
      for (var item in stdLessons!) {
        if (item.skills['hws'].isNotEmpty) {
          listScore.addAll(item.skills['hws']
              .where((element) => element['hw'] > -1)
              .map((e) => double.parse(e['hw'].toString())));
        } else if (item.skills['hw'] > -1) {
          listScore.add(item.skills['hw']);
        }
      }

      double hwTotal = listScore.fold(0, (a, b) => a + b);
      avgScoreHomeWork = listScore.isEmpty ? 0 : hwTotal / listScore.length;

      //test avg score
      var test = stdTests!.where((j) => j.score > -1).toList();
      double testTotal = test.fold(0, (a, b) => a + b.score);
      avgScoreTest = test.isEmpty ? 0 : testTotal / test.length;

      attendPercent =
          listLessonId.isNotEmpty ? attendCount / listLessonId.length : 0.0;
      homeworkPercent =
          listLessonId.isNotEmpty ? homeworkCount / listLessonId.length : 0.0;
    }

    emit(state + 1);
  }

  loadClass(Object classModel) {
    this.classModel = classModel as ClassModel;
  }

  loadLesson(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
  }

  loadTestResult(Object testResults) {
    this.testResults = testResults as List<TestResultModel>;
  }

  loadStudentTests(Object studentTests) {
    stdTests = studentTests as List<StudentTestModel>;
  }

  loadStudentLessons(Object studentLessons) {
    stdLessons = studentLessons as List<StudentLessonModel>;
  }
}

class LoadPercentItemClassCubit extends Cubit<int>{
  LoadPercentItemClassCubit(): super(0);
  int numLessonOpened = 0;
  int numAllLesson = 0;
  List<LessonModel>? lessons;
  List<LessonResultModel>? lessonResults;

  load(ClassModel? classModel)async{
    if(classModel != null){
      await CacheDataProvider.lessonOfClass(classModel.courseId,classModel.classId, classModel.customLesson ,loadLesson);
      await CacheDataProvider.lessonResultsByClassId(classModel.classId, loadLessonResult);
      numAllLesson = lessons!.length + classModel.customLesson.length;
      numLessonOpened = lessonResults!.length;
    }
    emit(state+1);
  }
  loadLesson(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }
  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
  }
}
