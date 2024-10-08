import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/home/user_class_cubit.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/lesson_result_model.dart';
import 'package:sae_chang/models/base_model/student_lesson_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';
import 'package:sae_chang/shared_preferences.dart';

class LessonsCubit extends Cubit<int> {
  LessonsCubit(this.userClass) : super(0);

  final UserClassModel userClass;

  List<LessonModel>? lessons;
  List<StudentLessonModel>? stdLessons;
  List<LessonResultModel>? lessonResults;

  ClassModel? classModel;

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  load() async {
    if (ConnectCubit.instance.state) {
      await CacheDataProvider.classById(userClass.classId, loadClass);

      await CacheDataProvider.lessonResultsByClassId(userClass.classId, loadLessonResult);

      await CacheDataProvider.studentLessonsByClassId(userClass.classId,userClass.userId, loadStudentLessons);

      await CacheDataProvider.lessonOfClass(classModel!.courseId,userClass.classId, classModel!.customLesson ,loadLessons);

      if (lessons!.any((element) => element.order != 0)) {
        lessons!.sort((a, b) => a.order.compareTo(b.order));
      }

      if(lessonResults!.isNotEmpty){
        var listRes = List.of(lessonResults!)
          ..sort((a, b) {
            DateTime dateTimeA = DateTime.fromMillisecondsSinceEpoch(a.dateTime);
            DateTime dateTimeB = DateTime.fromMillisecondsSinceEpoch(b.dateTime);
            return dateTimeA.compareTo(dateTimeB);
          });
        var listBase = <LessonModel>[];
        for (var item in listRes) {
          for (var lesson in lessons!) {
            if (lesson.lessonId == item.lessonId) {
              listBase.add(lesson);
              break;
            }
          }
        }
        var listSortOrder = List.of(lessons!)
          ..removeWhere((element) => listBase.contains(element));

        var listCustomLessonNotOpen = listSortOrder
            .where((element) =>
        element.courseId == 0 || element.customLessonsInfo.isNotEmpty)
            .toList();

        listSortOrder.removeWhere((element) =>
        element.courseId == 0 || element.customLessonsInfo.isNotEmpty);
        if (listSortOrder.any((element) => element.order != 0)) {
          listSortOrder.sort((a, b) => a.order.compareTo(b.order));
        }
        lessons = List.of(listBase
          ..addAll(listSortOrder)
          ..addAll(listCustomLessonNotOpen));
      }

      String toJsonLessons = LessonModel.encode(lessons!);
      await BaseSharedPreferences.setString(
          'lesson_class_${userClass.classId}', toJsonLessons);
    } else {
      var savedList = await BaseSharedPreferences.getString(
          'lesson_class_${userClass.classId}');
      if (savedList.isEmpty) {
        lessons = [];
      } else {
        lessons = LessonModel.decode(savedList);
      }
    }

    emitState();
  }

  LessonResultModel? getLessonResult(int lessonId){
    if(lessonResults == null) return null;
    var lessonResult = lessonResults!.where((e)=>e.lessonId == lessonId);
    if(lessonResult.isEmpty) return null;
    return lessonResult.first;
  }

  StudentLessonModel? getStdLesson(int lessonId){
    if(stdLessons == null) return null;
    var stdLesson = stdLessons!.where((e)=>e.lessonId == lessonId);
    if(stdLesson.isEmpty) return null;
    return stdLesson.first;
  }

  bool checkPreStudy(int lessonId){

    return false;
  }

  loadClass(Object classModel) {
    this.classModel = classModel as ClassModel;
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
  }

  loadStudentLessons(Object studentLessons) {
    stdLessons = studentLessons as List<StudentLessonModel>;
  }

  loadLessons(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }
}
