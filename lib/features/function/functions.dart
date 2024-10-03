import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sae_chang/models/base_model/question_model.dart';

class Functions {
  static void goPage(BuildContext context, String route, {Object? arguments}) async {
    await Navigator.pushNamed(context, route, arguments: arguments);
  }

  static bool checkIgnoreQuestion(QuestionModel ques) {
    if(ques.answered.isEmpty) {
      return true;
    }
    else {
      if (ques.questionType == 7) {
        return ques.answered
            .any((element) => RegExp(r'^\s*$').hasMatch(element));
      }
      else if (ques.questionType == 8) {
        return ques.answered
            .where((element) => element.contains('|'))
            .length < ques.answered.length;
      }
      else {
        return false;
      }
    }
  }


  static String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  static void logDebug(String data) {
    debugPrint('/-----------------------------/');
    debugPrint('=>>>>>>>>>>>>>>>>debug: $data');
    debugPrint('/-----------------------------/');
  }

  static String convertDirectory(String path) {

    if(File(path).existsSync()) {
      return path;
    }
    List<String> parts = path.split('Documents/');
    String relativePath = parts.length > 1 ? parts[1] : "";
    if(relativePath.isNotEmpty) {

      var file = '${DirectoryAppService.instance.dirApp}/$relativePath';
      if(File(file).existsSync() || Directory(file).existsSync()) {
        return file;
      }
    }
    return path;
  }
}

class DirectoryAppService {
  DirectoryAppService._privateConstructor();

  static final DirectoryAppService _instance = DirectoryAppService._privateConstructor();

  static DirectoryAppService get instance => _instance;

  String dirApp = '';
  init() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    dirApp = appDocDir.path;
  }
}