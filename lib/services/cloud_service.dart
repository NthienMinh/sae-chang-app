import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import '../shared_preferences.dart';


class CloudService {
  void uploadToFb(String style,int id, int resultId, QuestionModel question, int type,
      BuildContext context, [ Function()? onSubmit]) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('flase: ${question.id.toString()}');
    question.listUrl.clear();
    var internetConnected = true;
    try {
      if (context.mounted && !context.read<ConnectCubit>().isClosed) {
        internetConnected = context.read<ConnectCubit>().state;
      }
    }
    catch(e) {
      Functions.logDebug('errror conect: $e');
    }

    var key = await BaseSharedPreferences.getKey(style, id, resultId, 'history_upload');

    await Future.forEach(question.answered, (item) async {
      var storagePath = '${type == 0 ? 'question_result_image' : 'question_voice_records'}/${type == 0 ? 'image' : 'audio'}_${question.answered.indexOf(item)}_question_${question.id}_lesson_${id}_result_$resultId${type == 0 ? '.png' : ''}';

      try {
        Reference reference = FirebaseStorage.instance.ref(storagePath);

        await Future.delayed(const Duration(seconds: 1));
        if(!File(item).existsSync()) {
          question.listUrl = ['error'];
          return;

        }

        UploadTask uploadTask = reference.putFile(
          File(item),
          SettableMetadata(contentType: type == 1 ? 'audio/mpeg' : null),
        );

        StreamSubscription<TaskSnapshot>? task;
        task =
            uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {

          if (!internetConnected) {
            if (question.listUrl.length < question.answered.length) {
              question.listUrl.add('failed');
            }

            task!.cancel();
            return;
          }

          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              debugPrint("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              debugPrint("Upload is paused");
              if (question.listUrl.length < question.answered.length) {
                question.listUrl.add('failed');
              }
              break;
            case TaskState.canceled:
              debugPrint("Upload is canceled");
              if (question.listUrl.length < question.answered.length) {
                question.listUrl.add('failed');
              }
              break;
            case TaskState.error:
              debugPrint("Upload is error");
              if (question.listUrl.length < question.answered.length) {
                question.listUrl.add('failed');
              }
              break;
            case TaskState.success:
              if (question.listUrl.length < question.answered.length) {
                var url = (await taskSnapshot.ref.getDownloadURL());
                question.listUrl.add(url);
                if(onSubmit != null && question.listUrl.length == question.answered.length) {
                  onSubmit();
                }
                await saveUrlLocal(key, url, question);
              }
              break;
          }
        });
      } on Exception catch (err) {
        debugPrint('failed: $err');

        if (question.listUrl.length < question.answered.length) {
          question.listUrl.add('failed');
        }

        Fluttertoast.showToast(
            msg:
                'FirebaseException fail => listUrl : ${question.listUrl.length} | answered:${question.answered.length}',
            toastLength: Toast.LENGTH_LONG);
      }
    }).whenComplete(() {}).timeout( Duration(seconds: question.answered.length * 180), onTimeout: () {
      question.listUrl = ['error'];
      return;
    });

  }

  saveUrlLocal(String key, String url, QuestionModel question) async {
    final list = await SharePreferencesListProvider.instance.getList(key);
    List<dynamic> maps = list.map((e) => jsonDecode(e)).toList();
    List<Map<String, dynamic>> convertedList = maps.map((element) {
      return Map<String, dynamic>.from(element);
    }).toList();
    var index = convertedList
        .map((e) => e['id'])
        .toList()
        .indexWhere((element) => element == question.id);

    if (index != -1) {
      list.removeAt(index);
    }
    var json = {'id': question.id, 'url': question.listUrl};
    list.add(jsonEncode(json));
    if (kDebugMode) {
      print(list);
    }
    await SharePreferencesListProvider.instance.setListString(key, list);
  }

  Future<List<String>> getListUrlUploaded(
      String key, QuestionModel question) async {
    final list = await SharePreferencesListProvider.instance.getList(key);
    List<dynamic> maps = list.map((e) => jsonDecode(e)).toList();
    List<Map<String, dynamic>> convertedList = maps.map((element) {
      return Map<String, dynamic>.from(element);
    }).toList();
    var index = convertedList
        .map((e) => e['id'])
        .toList()
        .indexWhere((element) => element == question.id);

    if (index != -1) {
      return (convertedList[index]['url'] as List)
          .map((e) => e.toString())
          .toList();
    }
    return [];
  }

  Future<void> checkFileExistence() async {
    String filePath =
        'question_voice_records/audio_0_question_289_lesson_103542_student_308_class_117';

    try {
      // Get a reference to the file
      Reference reference = FirebaseStorage.instance.ref(filePath);

      // Get the download URL
      await reference.getDownloadURL();

      // File exists
      debugPrint('File exists');
    } catch (e) {
      // File doesn't exist
      debugPrint('File does not exist');
    }
  }

  bool checkConnect(BuildContext context) {
    var internetConnected = true;
    if (context.mounted && !context.read<ConnectCubit>().isClosed) {
      internetConnected = context.read<ConnectCubit>().state;
    }
    return internetConnected;
  }


  Future<bool> isUrlDownloadable(String url) async {
    try {
      final response = await Dio().head(url);
      if (response.statusCode == 200) {
        // You can further check for headers to determine if it's downloadable
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}


