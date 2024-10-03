import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/models/skill_models/word.dart';

import 'download_course_provider.dart';

class VocabularyProvider extends DownloadCourseProvider {

  VocabularyProvider._privateConstructor();

  static final VocabularyProvider _instance = VocabularyProvider._privateConstructor();

  static VocabularyProvider get instance => _instance;

  String folder = 'vocabulary';
  downloadFile(BuildContext context, int id, String token, int dataVersion) async {
    String url =  AppConfigs.getUrl(id, token, folder);
    await downloadFileAndSave(context , id, url, folder,folder,dataVersion);
  }
  Future<List<Word>> getWords(String dir) async {
    var listWord = <Word>[];
    final List<Map<String, dynamic>>? result = await getJsonData(dir,folder);
    if(result != null) {
      for (var item in result) {
        if (result.isNotEmpty) {
          listWord.add(Word.fromJson(item));
        }
      }
    }
    return listWord;
  }
}