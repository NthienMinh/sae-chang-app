import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/models/base_model/question_model.dart';

import 'download_course_provider.dart';

class BtvnProvider extends DownloadCourseProvider {
  BtvnProvider._privateConstructor();

  static final BtvnProvider instance = BtvnProvider._privateConstructor();

  String folder = 'btvn';
  Directory? directory;

  Future downloadFile(BuildContext context, int id, String token, int dataVersion) async {
    String url = AppConfigs.getBTVNUrl(id, token);
    await downloadFileAndSave(context, id, url, folder, 'test',dataVersion );
  }

  Future<List<QuestionModel>> getBtvns(String dir) async {
    var listBtvn = <QuestionModel>[];
    final List<Map<String, dynamic>>? result = await getJsonData(dir,folder);
    if (result != null) {
      for (var item in result) {
        debugPrint('=>>>>>>$item'.toString());
        if (result.isNotEmpty) {
          listBtvn.add(QuestionModel.fromMap(item));
        }
      }
    }
    return listBtvn;
  }
}
