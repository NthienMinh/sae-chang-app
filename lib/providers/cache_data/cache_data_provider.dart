
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/test_model.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';

class CacheObject {
  Object? data;
  DateTime time;

  CacheObject(this.time, {this.callbacks = const []});

  List<Function(Object)> callbacks;
}

class CacheDataProvider {
  static Map<String, CacheObject> cached = {};

  static Future<void> clearAllKey()async{
    cached.clear();
  }

  static Future<void> clearKey(String key)async{
    cached.remove(key);
  }

  static Future<void> classById(
      int id, Function(Object) onLoaded) async {
    var key = 'class_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getClassById(id);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> lessonResultsByClassId(
      int id, Function(Object) onLoaded) async {
    var key = 'lesson_results_class_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getLessonResultsByClassId(id);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> testResultsByClassId(
      int id, Function(Object) onLoaded) async {
    var key = 'test_results_class_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getTestResultsByClassId(id);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> studentLessonsByClassId(
      int id,int userId, Function(Object) onLoaded) async {
    var key = 'student_lessons_class_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getStudentLessonsByClassId(id,userId);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> studentTestsByClassId(
      int id,int userId, Function(Object) onLoaded) async {
    var key = 'student_tests_class_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getStudentTestsByClassId(id,userId);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> lessonOfClass(
      int courseId, int classId,List<dynamic> customLessons , Function(Object) onLoaded) async {
    var key = 'lesson_of_class_$classId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);

      List<LessonModel> lessons =  await FireBaseProvider.instance.getLessonsByCourseId(courseId);

      lessons.addAll(FireBaseProvider.instance.getCustomLessons(customLessons));

      cached[key]!.data = lessons;

      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> testOfClass(
      int courseId, int classId,List<dynamic> customLessons , Function(Object) onLoaded) async {
    var key = 'test_of_class_$classId';

    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);

      List<TestModel> tests =  await FireBaseProvider.instance.getTestsByCourseId(courseId);

      tests.addAll(await FireBaseProvider.instance.getCustomTests(customLessons));

      cached[key]!.data = tests;

      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }
}