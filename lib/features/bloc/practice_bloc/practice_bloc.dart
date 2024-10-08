import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart' hide Ink;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sae_chang/configs/prefKeys_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_state.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/models/base_model/course_model.dart';
import 'package:sae_chang/models/base_model/custom_lesson_hw.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:sae_chang/models/base_model/student_lesson_model.dart';
import 'package:sae_chang/models/base_model/student_test_model.dart';
import 'package:sae_chang/models/base_model/test_model.dart';
import 'package:sae_chang/providers/download/btvn_provider.dart';
import 'package:sae_chang/providers/download/test_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/providers/firebase/firestore_db.dart';
import 'package:sae_chang/services/cloud_service.dart';
import 'package:sae_chang/services/download_controller.dart';
import 'package:sae_chang/services/progress_service.dart';
import 'package:sae_chang/shared_preferences.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_toast.dart';
import 'package:sae_chang/untils/replace_text.dart';
import 'package:sae_chang/untils/split_text.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  late List<QuestionModel> _questions;
  late int _index;

  late Map<String, dynamic>? savedData;
  Map<int, List<StrokePoint>> mapStrokes = {};
  final digitalInkRecognizer = DigitalInkRecognizer(languageCode: 'ja');
  final Ink ink = Ink();
  List<String> errorList = [];
  List<QuestionModel> listIgnore = [];
  double scoreAvg = 0;
  int numOfIgnore = 0;
  bool isMarkAuto = false;
  bool isOffline = false;
  double score = -1;
  int numQuestionIgnoreOrDone = 0;
  int userId = 0;
  int classId = 0;
  int id = 0;
  int dataId = 0;
  int resultId = 0;
  Timer? timer;
  int timeAutoSkip = 0;
  int numRight = 0;
  int numWrong = 0;
  bool isJumpToIgnoreQuestion = false;
  String dir = "";
  String role = 'student';

  autoSkip(Function() onNext) {
    return;
  }

  stopTimer() {
    timeAutoSkip = 0;
    cancelTimer();
  }

  cancelTimer() {
    timer?.cancel();
  }


  PracticeBloc() : super(LoadingState()) {
    on<StartEvent>((event, emit) async {

      role = await BaseSharedPreferences.getString(PrefKeyConfigs.role);
      classId = event.classId;
      userId = event.userId;
      dataId = event.dataId;
      id = event.id;
      resultId = event.resultId;
      listIgnore.clear();
      if (event.isDoAgain) {
        await removeAllDataHistory(event.type, event.id, event.resultId);
      }
      _index = 0;
      isOffline = event.isOffline;
      await _initializeData(event);
      await checkAndDownloadInk(event);
      await _getHistoryIndexQuestion(event);
      await _getHistoryPractice(event);
      _getListIgnore();
      emit(QuestionState(
        _questions,
        listIgnore,
        _questions[_index],
        _index,
        _questions.length,
      ));
    });
    on<UpdateDrawEvent>((event, emit) {
      debugPrint('=>>>>>>>>>> UpdateDrawEvent ${event.value}');
      if (event.value) {
        if (!listIgnore.map((e) => e.id).contains(_questions[_index].id)) {
          listIgnore.add(_questions[_index]);
        }
      } else {
        listIgnore
            .removeWhere((element) => element.id == _questions[_index].id);
      }
      listIgnore.sort((a, b) {
        final indexA = _questions.indexWhere((e) => e.id == a.id);
        final indexB = _questions.indexWhere((e) => e.id == b.id);
        return indexA.compareTo(indexB);
      });

      emit(QuestionState(
        _questions,
        listIgnore,
        _questions[_index],
        _index,
        _questions.length,
      ));
    });
    on<UpdateEvent>((event, emit) {
      debugPrint('=>>>>>>>>>> UpdateEvent - ${_questions[_index].id}');
      if (Functions.checkIgnoreQuestion(_questions[_index])) {
        if (!listIgnore.map((e) => e.id).contains(_questions[_index].id)) {
          listIgnore.add(_questions[_index]);
        }
      } else {
        listIgnore
            .removeWhere((element) => element.id == _questions[_index].id);
      }
      listIgnore.sort((a, b) {
        final indexA = _questions.indexWhere((e) => e.id == a.id);
        final indexB = _questions.indexWhere((e) => e.id == b.id);
        return indexA.compareTo(indexB);
      });

      emit(QuestionState(
        _questions,
        listIgnore,
        _questions[_index],
        _index,
        _questions.length,
      ));
    });
    on<NextEvent>((event, emit) {
      _index++;
      emit(QuestionState(
        _questions,
        listIgnore,
        _questions[_index],
        _index,
        _questions.length,
      ));
    });

    on<PreviousEvent>((event, emit) {
      _index--;

      emit(QuestionState(
        _questions,
        listIgnore,
        _questions[_index],
        _index,
        _questions.length,
      ));
    });

    on<JumpEvent>((event, emit) {
      _index = event.index;
      emit(QuestionState(
        _questions,
        listIgnore,
        _questions[_index],
        _index,
        _questions.length,
      ));
    });
    on<SubmitEvent>((event, emit) async {
      emit(SubmittingState());
      errorList.clear();
      scoreAvg = 0;
      numOfIgnore = 0;
      isMarkAuto = false;
      numQuestionIgnoreOrDone = 0;
      int time = DateTime.now().millisecondsSinceEpoch;
      if (!isOffline) {
        if (event.type == "test") {
          StudentTestModel? testState = await FireBaseProvider.instance.getTestState(event.id, event.resultId, userId, classId);
          if (testState == null) {
            await FireBaseProvider.instance.createStudentTest(time,event.id, event.resultId, userId, classId);
          }else{
            time = testState.id;
          }
        } else {
          StudentLessonModel? lessonState = await FireBaseProvider.instance.getLessonState(event.id, event.resultId, userId, classId);
          if (lessonState == null) {
            await FireBaseProvider.instance.createStudentLesson(time,event.id, event.resultId, userId, classId);
          }else{
            time = lessonState.id;
          }
        }
      }
      var context = event.context;
      var res = false;

      if (context.mounted && !isOffline) {
        res = await submitOnline(context, event.type, event.id, event.resultId);
      } else if (context.mounted) {
        res =
            await submitOffline(context, event.type, event.id, time);
      }

      if (!res) {
        emit(SubmitError(errorList));
      } else {
        if (!isOffline) {
          if (event.type == "btvn") {
            var keyFlipFlashcard = await BaseSharedPreferences.getKey(
              event.type,
              event.id,
              event.resultId,
              'flip_flashcard',
            );

            final timeFlashcard = await getSkillTime(
                'flashcard', event.resultId, event.id);
            final timeGrammar =
                await getSkillTime('grammar', event.resultId, event.id);
            final timeVocabulary = await getSkillTime(
                'vocabulary', event.resultId, event.id);
            final timeReading =
                await getSkillTime('reading', event.resultId, event.id);
            final timeListening = await getSkillTime(
                'listening', event.resultId, event.id);
            final flipFlashcard = (await SharePreferencesListProvider.instance
                    .getList(keyFlipFlashcard))
                .length;

            if (id != dataId) {
              StudentLessonModel? lessonState;
              lessonState = await FireBaseProvider.instance.getLessonState(
                  event.id, event.resultId , userId, classId);

              var listHw = lessonState!.skills['hws']
                  .map((e) => CustomLessonHw.fromMap(e))
                  .toList();

              var index = listHw
                  .indexWhere((element) => element.lessonId == dataId);
              if (index != -1) {
                listHw[index] = CustomLessonHw(
                    isMarkAuto ? double.parse(scoreAvg.toStringAsFixed(1)) : -1,
                    dataId);
              } else {
                listHw.add(CustomLessonHw(
                    isMarkAuto ? double.parse(scoreAvg.toStringAsFixed(1)) : -1,
                    dataId));
              }

              var map = {
                'hw': -1,
                'hws': listHw.map((e) => e.toJson()).toList(),
                "time_btvn": event.timePractice,
                "time_flashcard": timeFlashcard.isEmpty ? 0 : int.parse(timeFlashcard),
                "time_grammar": timeGrammar.isEmpty ? 0 : int.parse(timeGrammar),
                "time_listening": timeListening.isEmpty ? 0 : int.parse(timeListening),
                "time_reading": timeReading.isEmpty ? 0 : int.parse(timeReading),
                "time_vocabulary": timeVocabulary.isEmpty ? 0 : int.parse(timeVocabulary),
                "skip_btvn": numOfIgnore,
                "flip_flashcard": flipFlashcard
              };
              await FireBaseProvider.instance.updateLessonState(time, map);
            } else {
              var map = {
                'hw': isMarkAuto ? double.parse(scoreAvg.toStringAsFixed(1)) : -1,
                'hws':[],
                "time_btvn": event.timePractice,
                "time_flashcard": timeFlashcard.isEmpty ? 0 : int.parse(timeFlashcard),
                "time_grammar": timeGrammar.isEmpty ? 0 : int.parse(timeGrammar),
                "time_listening": timeListening.isEmpty ? 0 : int.parse(timeListening),
                "time_reading": timeReading.isEmpty ? 0 : int.parse(timeReading),
                "time_vocabulary": timeVocabulary.isEmpty ? 0 : int.parse(timeVocabulary),
                "skip_btvn": numOfIgnore,
                "flip_flashcard": flipFlashcard
              };
              await FireBaseProvider.instance.updateLessonState(time,map);

            }
          } else {
            var map = {
              'score':
                  isMarkAuto ? double.parse(scoreAvg.toStringAsFixed(1)) : -1,
              "time": event.timePractice,
              "skip": numOfIgnore
            };
            await FireBaseProvider.instance
                .updateTestState(time,map);
          }


        } else {
          // await DriftDbProvider.db.database.insertHistoryTestSakumi247(
          //     HistoryTestSakumi247Companion.insert(
          //         answerDate: answerDate,
          //         numQuestion: _questions.length,
          //         time: event.timePractice,
          //         skipQuestion: numOfIgnore,
          //         testId: event.testId,
          //         classId: int.parse(classId),
          //         score: scoreAvg.toString()));
        }
        // await FireBaseProvider.instance
        //     .updateUserCache(userId,DateTime.now().millisecondsSinceEpoch);
        emit(SubmittedState({
          'score':
              isMarkAuto ? double.parse(scoreAvg.toStringAsFixed(1)) : -1.0,
          'complete': true,
          'right': numRight,
          'wrong': numWrong,
          'answerDate': time
        }));

        await removeAllDataHistory(event.type, event.resultId, event.id);
      }
    });
  }

  int getTimeFromMap(Map map, String key) {
    if (map.containsKey(key)) {
      return map[key];
    }
    return 0;
  }

  removeAllDataHistory(String type, int resultId, int id) async {
    var keyUpload = await BaseSharedPreferences.getKey(type, id, resultId, 'history_upload');
    var keyTimeBtvn = await BaseSharedPreferences.getKey(type, id, resultId, 'time');
    var keyHistory = await BaseSharedPreferences.getKey(type, id, resultId, 'history');
    var keyPractice = await BaseSharedPreferences.getKey(type, id, resultId, 'practice');

    await BaseSharedPreferences.removeJsonToPref(keyUpload);
    await BaseSharedPreferences.removeJsonToPref(keyHistory);
    await BaseSharedPreferences.removeJsonToPref(keyTimeBtvn);
    await BaseSharedPreferences.removeJsonToPref(keyPractice);

    if (type == 'DacNhan') {
      await BaseSharedPreferences.removeJsonToPref(
          'DacNhan_${id}_result_$resultId');
    }
  }

  Future<String> getSkillTime(
      String type, int resultId, int id) async {
    var keyTime =
        'id_${id}_result_${resultId}_skill_${type}_time';
    return await BaseSharedPreferences.getString(keyTime);
  }

  Future<void> _initializeData(StartEvent event) async {
    var courseId = 0;
    if(event.type == "test"){
      TestModel test =await FireBaseProvider.instance.getTestById(event.dataId);
      courseId = test.courseId;
    }else{
      LessonModel lesson = await FireBaseProvider.instance.getLessonById(dataId);
      courseId = lesson.courseId;
    }

    CourseModel course = (await FireBaseProvider.instance.getCourseByIds([courseId])).first;

    String token = course.dataToken;
    String dir = await DownLoadController.getDownloadFolder(
      event.dataId,
      event.type == "test" ? "test" : "btvn",course.dataVersion
    );

    this.dir = dir;

    final context = event.context;
    List<QuestionModel> data = [];
    if (event.type == "DacNhan") {
      // if (event.id > 100) {
      //   List<Test247Model> listTest247Model =
      //       await Sakumi247Repository.getTestByLevel(event.level!);
      //   List<int> listType = [];
      //   List<int> numQuestionLevel = [];
      //   for (var i in listTest247Model) {
      //     int num = 0;
      //     switch (i.subType) {
      //       case 5:
      //       case 6:
      //         num = (event.numOfQuestion * 0.2).round();
      //         listType.add(i.id);
      //         numQuestionLevel.add(num);
      //       case 1:
      //       case 7:
      //       case 8:
      //       case 9:
      //         num = (event.numOfQuestion * 0.1).round();
      //         listType.add(i.id);
      //         numQuestionLevel.add(num);
      //     }
      //   }
      //   listType.add(listTest247Model.where((e) => e.subType == 4).first.id);
      //
      //   var temp = [...listType].where((id) => listTest247Model.firstWhere((l) => l.id == id).dir != 0).toList();
      //   await SlMultipleTestProvider.instance.downloadFile(
      //       context, temp.map((e) => e.toString()).toList(), token);
      //
      //   int sum = numQuestionLevel.fold(0, (acc, e) => acc + e);
      //   numQuestionLevel.add(event.numOfQuestion - sum);
      //   data = await Sakumi247Repository.getQuestionsByListLevelAndNum(
      //       listType, numQuestionLevel);
      // } else {
      //   List<Test247Model> listTest247Model =
      //   await Sakumi247Repository.getTestByLevel(event.level!);
      //
      //   var item = listTest247Model.where((k) => k.id == event.testId).singleOrNull;
      //
      //   if(item != null && item.dir != 0) {
      //     await SlTestProvider.instance
      //         .downloadFile(context, event.testId.toString(), token);
      //   }
      //   data = await Sakumi247Repository.getQuestionsByLevelAndNum(
      //       event.testId, event.numOfQuestion);
      // }
      data = [];
    } else if (event.type == "test") {
      if (context.mounted) {
        await TestProvider.instance.downloadFile(context,
            event.id, token, event.dataId, course.dataVersion);
        data = await TestProvider.instance.getTests(dir);
      }
    } else {
      if (context.mounted) {
        await BtvnProvider.instance
            .downloadFile(context, event.dataId, token, course.dataVersion);
        data = await BtvnProvider.instance.getBtvns(dir);
      }
    }
    _questions = data;
  }

  Future _getHistoryIndexQuestion(
      StartEvent event) async {
    var keyHistory = await BaseSharedPreferences.getKey(
        event.type,
        event.id,
        event.resultId,
        'history');
    debugPrint('=>>>>historyId: $keyHistory');
    var historyId = await BaseSharedPreferences.getString(keyHistory);
    debugPrint('=>>>>historyId: $historyId');
    if (historyId.isNotEmpty) {
      _index = _questions
          .indexWhere((element) => element.id.toString() == historyId);
    }
    _index = _index == -1 ? 0 : _index;
  }

  Future _getHistoryPractice(
      StartEvent event) async {
    var context = event.context;

    var keySaved = await BaseSharedPreferences.getKey(
        event.type,
        event.id,
        event.resultId,
        'practice');

    savedData = await BaseSharedPreferences.getJsonFromPrefs(keySaved);

    var key = await BaseSharedPreferences.getKey(event.type,
        event.id,
        event.resultId, 'history_upload');
    if (savedData == null) {
      debugPrint("=========>lam lan dau ne");
    } else {
      for (var i in _questions) {
        var indexQ = _questions.indexOf(i);
        for (var j in savedData?['data']) {
          if (i.id == j['questionId']) {
            List<String> temp = [];
            for (var i in j['answer']) {
              temp.add(i);
            }
            i.answered = temp;
            if ([1, 5, 11, 44].contains(j['type'])) {
              List<String> a = [];
              for (var i in j['answerState']) {
                a.add(i);
              }
              i.answerState = a;
            }
            if ((j['type'] == 2 || j['type'] == 4) && (indexQ < _index)) {
              if (i.answered.isNotEmpty) {
                await i.checkAndRemoveFileNotExists();
                if (context.mounted && !isOffline) {
                  i.listUrl = await CloudService().getListUrlUploaded(key, i);
                  if (i.listUrl.length != i.answered.length) {
                    if (context.mounted) {
                      CloudService().uploadToFb(event.type,event.id, event.resultId, i, 0, context);
                    }
                  }
                }
              }
            }
            if ((j['type'] == 3 || j['type'] == 10) && (indexQ < _index)) {
              if (i.answered.isNotEmpty) {
                await i.checkAndRemoveFileNotExists();
                if (context.mounted && !isOffline) {
                  i.listUrl = await CloudService().getListUrlUploaded(key, i);
                  if (i.listUrl.length != i.answered.length) {
                    if (context.mounted) {
                      CloudService().uploadToFb(event.type,event.id, event.resultId, i, 1, context);
                    }
                  }
                }
              }
            }

            if (j['type'] == 7) {
              List<String> resultList = i.answered;
              List<String> splitList =
                  ReplaceText.replaceCharacterJapan(i.question).split("/");
              splitList.shuffle();
              i.answerState = splitList;
              for (var k in i.answerState) {
                if (resultList.contains(k)) {
                  i.answerState[i.answerState.indexOf(k)] = "";
                }
              }
            }
          }
        }
      }
    }
  }

  _getListIgnore() {
    for (var i in _questions) {
      if (Functions.checkIgnoreQuestion(i)) {
        if (!listIgnore.map((e) => e.id).contains(i.id)) {
          listIgnore.add(i);
        }
      }
    }
  }

  Future<void> waitQuestionProcessing(
      List<QuestionModel> submittingList, QuestionModel current) async {
    submittingList.removeAt(0);
    submittingList.add(current);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> submitOffline(
      BuildContext context, String type, int parentId, int dateAnswer) async {
    int numQ = 0;
    final dialog = ProgressService(context, false, 'submit');
    var submittingList = [..._questions];
    while (submittingList.isNotEmpty) {
      try {
        score = -1;
        var submitQue = _questions
            .firstWhere((element) => element.id == submittingList.first.id);
        await dialog.update((((++numQ) / _questions.length) * 100).toDouble());

        autoMarkQuestion(submitQue);
        if (score != -1) {
          if ([1, 5, 11, 7, 8, 22, 44].contains(submitQue.questionType)) {
            numQuestionIgnoreOrDone++;
            scoreAvg += score;
          }
        }

        await submitDocsOfflineDacNhan(
            parentId, score, submitQue, dateAnswer);

        submittingList.removeAt(0);
        debugPrint('=>>>>>>>>>>>>>>>removed Sucesss');
      } catch (err) {
        Fluttertoast.showToast(
            msg: err.toString(), toastLength: Toast.LENGTH_LONG);
        errorList.add(err.toString());
        break;
      }
    }

    if (errorList.isNotEmpty) return false;
    isMarkAuto = true;
    scoreAvg = _questions.isEmpty ? 0 : scoreAvg / numQuestionIgnoreOrDone;

    return true;
  }

  Future<bool> submitOnline(
      BuildContext context, String type, int id,int resultId ) async {
    int numQ = 0;

    try {
      if (context.mounted) {
        if (!context.read<ConnectCubit>().state) {
          errorList.add('Mạng không ổn định');
          return false;
        }
      }
    } catch (e) {
      Functions.logDebug(e.toString());
      return false;
    }

    final dialog = ProgressService(context, false, 'submit');
    CollectionReference submit = FireStoreDb.instance.db.collection('answers');

    var submittingList = [..._questions];

    while (submittingList.isNotEmpty) {
      try {
        score = -1;
        var submitQue = _questions
            .where((element) => element.id == submittingList.first.id)
            .first;
        if (submitQue.listUrl.contains('error')) {
          submitQue.answered.clear();
          submitQue.listUrl.clear();
          await dialog
              .update((((++numQ) / _questions.length) * 100).toDouble());
          autoMarkQuestion(submitQue);
          if (score != -1) {
            numQuestionIgnoreOrDone++;
            scoreAvg += score;
          }
          await submitDocsToFirebase(
              submit,resultId,id ,type, submitQue);
          submittingList.removeAt(0);
          continue;
        } else if (submitQue.listUrl.length < submitQue.answered.length &&
            [2, 4, 3, 10].contains(submitQue.questionType)) {
          await Future.delayed(const Duration(seconds: 1));
          await waitQuestionProcessing(submittingList, submitQue);
          continue;
        } else {
          if (submitQue.listUrl.contains('failed')) {
            Fluttertoast.showToast(
                msg:
                    'fail => length ${submittingList.length} \nsubmitQue ${submitQue.id} ${submitQue.question}');
            var index =
                _questions.indexWhere((element) => element.id == submitQue.id);
            var typeInt = [2, 4].contains(submitQue.questionType) ? 0 : 1;
            if (context.mounted) {
              CloudService()
                  .uploadToFb(type,id,resultId, _questions[index], typeInt, context);
            }
            await waitQuestionProcessing(submittingList, submitQue);
            continue;
          }
          await dialog
              .update((((++numQ) / _questions.length) * 100).toDouble());

          autoMarkQuestion(submitQue);
          if (score != -1) {
            numQuestionIgnoreOrDone++;
            scoreAvg += score;
          }

          submitDocsToFirebase(
              submit,resultId,id ,type, submitQue);

          submittingList.removeAt(0);
          debugPrint('=>>>>>>>>>>>>>>>removed Sucesss');
        }
      } catch (err) {
        Fluttertoast.showToast(
            msg: err.toString(), toastLength: Toast.LENGTH_LONG);
        errorList.add(err.toString());
        break;
      }
    }

    if (errorList.isNotEmpty) return false;
    if (numQuestionIgnoreOrDone == _questions.length) {
      isMarkAuto = true;
      scoreAvg = _questions.isEmpty ? 0 : scoreAvg / numQuestionIgnoreOrDone;
      if (scoreAvg > 10) {
        scoreAvg = -1;
      }
    }
    return true;
  }

  Future<void> submitDocsToFirebase(
    CollectionReference answerCollection,
    int resultId,
    int parentId,
    String type,
    QuestionModel model,
  )async {

    try {
      answerCollection
          .doc("${type}_student_${userId}_class_${classId}_parent_${parentId}_question_${model.id}")
          .set({
        'user_id': userId,
        'question_id': model.id,
        'score': score,
        'answer': [2, 4, 3, 10].contains(model.questionType)
            ? model.listUrl
            : model.answered,
        'parent_id': parentId,
        'question_type': model.questionType,
        'teacher_note': "",
        'type': type,
        'class_id': classId,
        'teacher_images_note': [],
        'teacher_records_note': [],
        'answerState':
            [1, 5, 11, 44].contains(model.questionType) ? model.answerState : [],
        'result_id': resultId,
        'data_id': dataId,
      }, SetOptions(merge: true)).whenComplete(() async {});
    } catch (e) {
      errorList.add(e.toString());
    }
  }

  submitDocsOfflineDacNhan(int id,
      double score, QuestionModel model, int dateAnswer) async {
    // try {
    //   await DriftDbProvider.db.database.insertAnswerSakumi247(
    //     AnswerSakumi247Companion.insert(
    //       answer: jsonEncode(model.answered),
    //       answerState: [1, 5, 11, 44].contains(model.questionType)
    //           ? jsonEncode(model.answerState)
    //           : '',
    //       classId: int.parse(classId),
    //       date: dateAnswer,
    //       parentId: testId,
    //       questionId: model.id,
    //       questionType: model.questionType,
    //       score: score.toString(),
    //       studentId: int.parse(id),
    //       type: type,
    //     ),
    //   );
    // } catch (e) {
    //   errorList.add(e.toString());
    // }
  }

  double convertScore(double score) {
    if (score == -1) return -1;
    if (score < 1.25) {
      return 0;
    } else if (score < 3.75) {
      return 2.5;
    } else if (score < 6.25) {
      return 5;
    } else if (score < 8.75) {
      return 7.5;
    } else {
      return 10;
    }
  }

  void autoMarkQuestion(QuestionModel submitQue) {
    if (submitQue.answered.isEmpty) {
      score = 0;
      numOfIgnore++;
    } else if (submitQue.questionType == 1 ||
        submitQue.questionType == 5 ||
        submitQue.questionType == 11) {
      var answer = CustomCheck.getAnswer(submitQue);
      if (answer != '' && submitQue.answered.isNotEmpty) {
        if (answer.trim() == submitQue.answered.first.trim()) {
          score = 10;
        } else {
          score = 0;
        }
      }
    } else if (submitQue.questionType == 7) {
      bool isIgnore = submitQue.answered
              .where((element) => RegExp(r'^\s*$').hasMatch(element))
              .length ==
          submitQue.answered.length;
      if (isIgnore) {
        numOfIgnore++;
      }
      var numOfTrue = 0;
      debugPrint('=>>>>submitQue.answered: ${submitQue.answered}');
      var ques =
          ReplaceText.replaceCharacterJapan(submitQue.question).split('/');
      for (var item in submitQue.answered) {
        var index = submitQue.answered.indexOf(item);
        if (index < ques.length && ques[index].trim() == item.trim()) {
          numOfTrue++;
        }
      }
      score = numOfTrue == ques.length ? 10 : 0;
      debugPrint('=>>>>score: $score');
    } else if (submitQue.questionType == 8) {
      bool isIgnore = submitQue.answered
              .where((element) => !element.contains('|'))
              .length ==
          submitQue.answered.length;
      if (isIgnore) {
        numOfIgnore++;
      }
      var numOfTrue = 0;
      var list1 = <Map<String, dynamic>>[];
      var list2 = <Map<String, dynamic>>[];
      List<String> splitList =
          ReplaceText.replaceCharacterJapan(submitQue.question)
              .replaceAll("-", "|")
              .split(";");
      for (var item in splitList) {
        debugPrint('=>>>>>>>>>>>>item: $item');
        var splitMap = SplitText().splitMatchColumn(item, '|');
        if (splitMap.length == 2) {
          list1.add({
            'text1': splitMap[0].trim(),
            'text2': splitMap[1].trim(),
          });
        }
      }
      debugPrint('+>>>>>list1: $list1');
      debugPrint('+>>>>>submitQue.answered: ${submitQue.answered}');
      for (var item in submitQue.answered) {
        var splitMap = SplitText().splitMatchColumn(item, '|');
        if (splitMap.length == 2) {
          list2.add({
            'text1': splitMap[0].trim(),
            'text2': splitMap[1].trim(),
          });
        }
      }
      debugPrint('+>>>>>list2: $list2');
      for (var item in list2) {
        if (list1.any((element) =>
            element["text1"] == item["text1"] &&
            element["text2"] == item["text2"])) {
          numOfTrue++;
        }
      }
      score = splitList.isEmpty || submitQue.answered.isEmpty
          ? 0
          : (10 / splitList.length) * numOfTrue;
      debugPrint('=>>>>score: $score');
    } else if (submitQue.questionType == 44) {
      if (submitQue.answered.isNotEmpty) {
        score = submitQue.answered.first.toLowerCase().trim() ==
                submitQue.answer.toLowerCase().trim()
            ? 10
            : 0;
      } else {
        score = 0;
      }
    } else if (submitQue.questionType == 22) {
      if (submitQue.answered.isNotEmpty) {
        score = 10;
      } else {
        score = 0;
      }
    }
    score = convertScore(score);
    score == 10 ? numRight++ : numWrong++;
  }

  checkAndDownloadInk(StartEvent event) async {
    if (_questions.any((element) => element.questionType == 44)) {
      final DigitalInkRecognizerModelManager modelManager =
          DigitalInkRecognizerModelManager();
      var language = 'ja';
      if (!CloudService().checkConnect(event.context)) {
        CustomToast.showBottomToast(
            event.context, AppText.txtInternetFailed.text);
        Navigator.pop(event.context);
      } else {
        double progress = 0;
        bool isDownloadGGMLKit = false;
        ProgressService dialog =
            ProgressService(event.context, false, 'download');
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
          if (isDownloadGGMLKit) {
            timer.cancel();
          } else {
            progress += 10;
            if (progress > 90) {
              progress = 90;
            }
            dialog.update(progress);
          }
        });
        var isDownloaded = await modelManager.isModelDownloaded(language);
        if(isDownloaded) {
          isDownloadGGMLKit = true;
          dialog.update(100);
          return;
        }
        else {
          await modelManager
              .downloadModel(language)
              .then((value) {
            isDownloadGGMLKit = true;
            dialog.update(100);
          });
        }
      }
    }
  }
}
