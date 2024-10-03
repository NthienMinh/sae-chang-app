import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/models/base_model/question_model.dart';

import 'download_course_provider.dart';



class TestProvider extends DownloadCourseProvider {
  TestProvider._privateConstructor();

  static final TestProvider instance = TestProvider._privateConstructor();

  String folder = 'test';
  Directory? directory;
  Future downloadFile(BuildContext context, int id , String token , int dataId,int dataVersion) async {
    String url = '';
    url =  AppConfigs.getTestUrl(dataId, token);
    if(context.mounted) {
      await downloadFileAndSave(context, id, url, folder, 'test',dataVersion );
    }
  }
  Future<List<QuestionModel>> getTests(String dir) async {
    var listTest= <QuestionModel>[];
    final List<Map<String, dynamic>>? result = await getJsonData(dir,folder);
    if(result != null) {
      for (var item in result) {
        debugPrint('=>>>>>>$item'.toString());
        if (result.isNotEmpty) {
          listTest.add(QuestionModel.fromMap(item));
        }
      }
    }
    return listTest;
  }

}
