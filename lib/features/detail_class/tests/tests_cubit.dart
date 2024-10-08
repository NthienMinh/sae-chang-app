import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/student_test_model.dart';
import 'package:sae_chang/models/base_model/test_model.dart';
import 'package:sae_chang/models/base_model/test_result_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';

class TestsCubit extends Cubit<int>{
  TestsCubit(this.userClass):super(0);

  final UserClassModel userClass;

  List<TestModel>? tests;
  List<TestResultModel>? testResults;
  List<StudentTestModel>? stdTests;

  ClassModel? classModel;

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  load()async{
    if (ConnectCubit.instance.state) {

      await CacheDataProvider.classById(userClass.classId, loadClass);

      await CacheDataProvider.testResultsByClassId(userClass.classId, loadTestResult);

      await CacheDataProvider.studentTestsByClassId(userClass.classId,userClass.userId, loadStudentTests);

      await CacheDataProvider.testOfClass(classModel!.courseId,userClass.classId, classModel!.customTest ,loadTests);

      if(testResults!.isNotEmpty){
        testResults!.sort(
              (a, b) {
            return a.dateAssign.compareTo(b.dateAssign);
          },
        );
      }



      // String toJsonLessons = LessonModel.encode(lessons!);
      // await BaseSharedPreferences.setString(
      //     'lesson_class_${userClass.classId}', toJsonLessons);
    } else {
      // var savedList = await BaseSharedPreferences.getString(
      //     'test_class_${userClass.classId}');
      // if (savedList.isEmpty) {
      //   tests = [];
      // } else {
      //   tests = TestModel.decode(savedList);
      // }
    }

    emitState();
  }

  dynamic getResult(int testResultId) {

    if(stdTests == null && stdTests!.isEmpty) return -2;

    var stdTest = stdTests!.where((e)=>e.testResultId == testResultId);

    if(stdTest.isEmpty) return -2;

    return stdTest.first.score;
  }

  TestModel getTest(int testId){
    return tests!.firstWhere((e)=>e.id == testId);
  }

  loadClass(Object classModel) {
    this.classModel = classModel as ClassModel;
  }

  loadTestResult(Object testResults) {
    this.testResults = testResults as List<TestResultModel>;
  }

  loadStudentTests(Object studentTests) {
    stdTests = studentTests as List<StudentTestModel>;
  }

  loadTests(Object tests) {
    this.tests = tests as List<TestModel>;
  }

}