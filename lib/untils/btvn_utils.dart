// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
// import 'package:sae_chang/models/base_model/question_model.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'custom_check.dart';
//
// class BtvnUtils {
//   final QuestionState state;
//   final PracticeBloc bloc;
//   final Function() onSubmit;
//   final int count = AppConfigs.countDraw;
//   final ScreenshotController screenshotController;
//   final String type;
//   final bool isStudent;
//   final bool isOffline;
//   final DrawingsController drawController;
//   final AudioRecorder audioRecorder;
//
//   BtvnUtils({
//     required this.state,
//     required this.bloc,
//     required this.onSubmit,
//     required this.screenshotController,
//     required this.type,
//     required this.isStudent,
//     required this.drawController,
//     required this.isOffline,
//     required this.audioRecorder,
//   });
//
//   upload(int id, int resultId, int t, BuildContext context) {
//     debugPrint('llllllllllllllllllll${state.question.answered}');
//     if (state.question.answered.isNotEmpty) {
//       if (type == 'test' && !isOffline && isStudent) {
//         CloudService().uploadToFb(
//             type, id, resultId, state.question, t, context);
//       } else {
//         CloudService().uploadToFb(
//           type,
//           id,
//           resultId,
//           state.question,
//           t,
//           context,
//         );
//       }
//     } else {
//       state.question.listUrl = [];
//     }
//   }
//
//   Future imageSaveAndUpload(int id, int resultId) async {
//     if (drawController.points.isEmpty) {
//       BaseSharedPreferences.savePracticeData(state.question, type, id, resultId);
//       state.question.answered = [];
//       bloc.add(UpdateEvent());
//       return;
//     }
//     debugPrint('=>>>>>>>>>>>>>now image: ${state.question.answered}');
//     final Directory appDocDir = await getApplicationDocumentsDirectory();
//     final imagePath =
//         '${appDocDir.path}/draw/result_${resultId}_lesson_${id}_question_${state.question.id}';
//     debugPrint(imagePath);
//     final imageBytes =
//         await screenshotController.captureAndSave(imagePath, pixelRatio: 2.0);
//     state.question.answered = [imageBytes!];
//     debugPrint('=>>>>>>>>>>>>>write Again: ${state.question.answered}');
//     AppConfigs.countDraw++;
//     bloc.add(UpdateEvent());
//     BaseSharedPreferences.savePracticeData(state.question, type, id, resultId);
//   }
//
//   Future onPrevious(int id, int resultId) async {
//     if (SpeechToText().isAvailable) {
//       await SpeechToText().stop();
//     }
//     bloc.stopTimer();
//     if (state.practiceIndex == 0) return;
//
//     if (state.question.questionType == 44) {
//       await inkRecognizer(id,resultId);
//     }
//     if (state.question.questionType == 22) {
//       await speakRecognize(id, resultId);
//     }
//     if (state.question.questionType == 4 &&
//         (state.question.answered.isEmpty || count != AppConfigs.countDraw)) {
//       await imageSaveAndUpload(id, resultId);
//     }
//     MediaService.instance.stop();
//     if (state.question.questionType == 3 || state.question.questionType == 10) {
//       audioRecorder.stop();
//     }
//     if (VideoService.instance.player != null) {
//       VideoService.instance.dispose();
//     }
//     if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0 &&
//         state.question.questionType == 6) {
//       FocusManager.instance.primaryFocus?.unfocus();
//     }
//     bloc.add(PreviousEvent());
//   }
//
//   Future handleNext(BuildContext context, int dataId, int id, int classId,
//       int userId, int resultId, bool isSubmit,
//       [int value = -1]) async {
//     if (SpeechToText().isAvailable) {
//       await SpeechToText().stop();
//     }
//     bloc.stopTimer();
//     MediaService.instance.stop();
//     if (state.question.questionType == 44) {
//       await inkRecognizer(id, resultId);
//     }
//     if (state.question.questionType == 22) {
//       await speakRecognize(id, resultId);
//     }
//     if (state.question.questionType == 3 || state.question.questionType == 10) {
//       if (context.mounted && !isOffline) {
//         upload(id, resultId, 1, context);
//       } else {
//         debugPrint('not mounted');
//       }
//       audioRecorder.stop();
//     }
//     if (state.question.questionType == 4 &&
//         (state.question.answered.isEmpty || count != AppConfigs.countDraw)) {
//       await imageSaveAndUpload(id, resultId);
//     }
//     if (state.question.questionType == 2 || state.question.questionType == 4) {
//       if (context.mounted && !isOffline) {
//         upload(id, resultId, 0, context);
//       } else {
//         debugPrint('not mounted');
//       }
//     }
//
//     if (VideoService.instance.player != null) {
//       VideoService.instance.pause();
//     }
//     if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0 &&
//         state.question.questionType == 6) {
//       FocusManager.instance.primaryFocus?.unfocus();
//     }
//
//     if (type == 'test' && !isOffline && isStudent) {
//       if (![2, 3, 4, 10].contains(state.question.questionType)) {
//         submitToFirebase(dataId,id,classId, userId, resultId);
//       }
//     }
//
//     if (isSubmit) {
//       if (isStudent) {
//         await onSubmit();
//       } else {
//         if (context.mounted) {
//           Navigator.pop(context);
//         }
//       }
//     } else {
//       debugPrint('answered${state.question.answered}');
//
//       if (value != -1) {
//         bloc.add(JumpEvent(value));
//       } else {
//         if (bloc.isJumpToIgnoreQuestion) {
//           for (var item in state.listIgnore) {
//             final idx = state.listQuestions
//                 .indexWhere((element) => element.id == item.id);
//             final idxLast = state.listQuestions.indexWhere(
//                 (element) => element.id == state.listIgnore.last.id);
//             if (idx == idxLast) {
//               bloc.add(NextEvent());
//               break;
//             }
//             if (idx > state.practiceIndex) {
//               bloc.add(JumpEvent(idx));
//               break;
//             }
//           }
//
//           if (state.listIgnore.isEmpty) {
//             bloc.add(JumpEvent(state.listQuestions.length - 1));
//           }
//         } else {
//           bloc.add(NextEvent());
//         }
//       }
//     }
//   }
//
//   autoNext(BuildContext context, int type, int dataId, int id, int classId,
//       int userId, int resultId) {
//     Functions.logDebug('onNext');
//     if (type == 1 || type == 5) {
//       if (bloc.timeAutoSkip > 2) {
//         handleNext(
//             context,dataId, id,classId,userId, resultId, state.practiceIndex == state.count - 1);
//       }
//     }
//     if (type == 8 || type == 7) {
//       if (bloc.timeAutoSkip > 3) {
//         handleNext(
//             context, dataId, id,classId,userId, resultId, state.practiceIndex == state.count - 1);
//       }
//     }
//   }
//
//   submitToFirebase(
//       int dataId, int id, int classId, int userId, int resultId) async {
//     double score = autoMarkQuestion(state.question);
//     CollectionReference submit = FireStoreDb.instance.db.collection('answers');
//
//     submitDocsToFirebase(submit, dataId, id, classId, type, userId, resultId,
//         score, state.question);
//   }
//
//   double autoMarkQuestion(QuestionModel submitQue) {
//     double score = -1;
//     if (submitQue.answered.isEmpty) {
//       score = 0;
//     } else if (submitQue.questionType == 1 ||
//         submitQue.questionType == 5 ||
//         submitQue.questionType == 11) {
//       var answer = CustomCheck.getAnswer(submitQue);
//       if (answer != '' && submitQue.answered.isNotEmpty) {
//         if (answer.trim() == submitQue.answered.first.trim()) {
//           score = 10;
//         } else {
//           score = 0;
//         }
//       }
//     } else if (submitQue.questionType == 7) {
//       var numOfTrue = 0;
//       debugPrint('=>>>>submitQue.answered: ${submitQue.answered}');
//       var ques =
//           ReplaceText.replaceCharacterJapan(submitQue.question).split('/');
//       for (var item in submitQue.answered) {
//         var index = submitQue.answered.indexOf(item);
//         if (index < ques.length && ques[index].trim() == item.trim()) {
//           numOfTrue++;
//         }
//       }
//       score = numOfTrue == ques.length ? 10 : 0;
//       debugPrint('=>>>>score: $score');
//     } else if (submitQue.questionType == 8) {
//       var numOfTrue = 0;
//       var list1 = <Map<String, dynamic>>[];
//       var list2 = <Map<String, dynamic>>[];
//       List<String> splitList =
//           ReplaceText.replaceCharacterJapan(submitQue.question)
//               .replaceAll("-", "|")
//               .split(";");
//       for (var item in splitList) {
//         debugPrint('=>>>>>>>>>>>>item: $item');
//         var splitMap = SplitText().splitMatchColumn(item, '|');
//         if (splitMap.length == 2) {
//           list1.add({
//             'text1': splitMap[0].trim(),
//             'text2': splitMap[1].trim(),
//           });
//         }
//       }
//       debugPrint('+>>>>>list1: $list1');
//       debugPrint('+>>>>>submitQue.answered: ${submitQue.answered}');
//       for (var item in submitQue.answered) {
//         var splitMap = SplitText().splitMatchColumn(item, '|');
//         if (splitMap.length == 2) {
//           list2.add({
//             'text1': splitMap[0].trim(),
//             'text2': splitMap[1].trim(),
//           });
//         }
//       }
//       debugPrint('+>>>>>list2: $list2');
//       for (var item in list2) {
//         if (list1.any((element) =>
//             element["text1"] == item["text1"] &&
//             element["text2"] == item["text2"])) {
//           numOfTrue++;
//         }
//       }
//
//       score = splitList.isEmpty || submitQue.answered.isEmpty
//           ? 0
//           : (10 / splitList.length) * numOfTrue;
//       debugPrint('=>>>>score: $score');
//     } else if (submitQue.questionType == 44) {
//       if (submitQue.answered.isNotEmpty) {
//         score = submitQue.answered.first.toLowerCase().trim() ==
//                 submitQue.answer.toLowerCase().trim()
//             ? 10
//             : 0;
//       } else {
//         score = 0;
//       }
//     }
//     return convertScore(score);
//   }
//
//   inkRecognizer(int id, int resultId) async {
//     if (bloc.ink.strokes.isEmpty) return;
//     final candidates = await bloc.digitalInkRecognizer.recognize(bloc.ink);
//     if (candidates.isNotEmpty) {
//       state.question.answered = [candidates.first.text];
//
//       if (kDebugMode) {
//         print(state.question.answered);
//       }
//       state.question.answerState =
//           bloc.ink.strokes.map((e) => jsonEncode(e)).toList();
//       bloc.ink.strokes.clear();
//       bloc.add(UpdateEvent());
//       BaseSharedPreferences.savePracticeData(
//           state.question, type, id, resultId);
//     }
//   }
//
//   speakRecognize(int id, int resultId) async {
//     bloc.add(UpdateEvent());
//     BaseSharedPreferences.savePracticeData(state.question, type, id, resultId);
//   }
// }
//
// void submitDocsToFirebase(
//   CollectionReference answerCollection,
//   int dataId,
//   int parentId,
//   int classId,
//   String type,
//   int userId,
//   int resultId,
//   double score,
//   QuestionModel model,
// ) {
//   try {
//     var doc = "${type}_${parentId}_student_${userId}_result_$resultId";
//     answerCollection.doc(doc).set({
//       'user_id': userId,
//       'question_id': model.id,
//       'score': score,
//       'answer': [2, 4, 3, 10].contains(model.questionType)
//           ? model.listUrl
//           : model.answered,
//       'parent_id': parentId,
//       'question_type': model.questionType,
//       'teacher_note': "",
//       'type': type,
//       'class_id': classId,
//       'teacher_images_note': [],
//       'teacher_records_note': [],
//       'answerState': model.questionType == 1 ||
//               model.questionType == 5 ||
//               model.questionType == 11
//           ? model.answerState
//           : [],
//       'result_id': resultId,
//       'data_id': dataId,
//     }, SetOptions(merge: true)).whenComplete(() async {});
//   } catch (e) {
//     if (kDebugMode) {
//       print(e);
//     }
//   }
// }
//
// double convertScore(double score) {
//   if (score == -1) return -1;
//   if (score < 1.25) {
//     return 0;
//   } else if (score < 3.75) {
//     return 2.5;
//   } else if (score < 6.25) {
//     return 5;
//   } else if (score < 8.75) {
//     return 7.5;
//   } else {
//     return 10;
//   }
// }
