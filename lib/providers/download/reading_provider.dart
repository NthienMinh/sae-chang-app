import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/models/skill_models/word.dart';

import 'download_course_provider.dart';

class ReadingProvider extends DownloadCourseProvider {
  ReadingProvider._privateConstructor();

  static final ReadingProvider _instance =
      ReadingProvider._privateConstructor();

  static ReadingProvider get instance => _instance;

  String folder = 'reading';
  downloadFile(
      BuildContext context, int id, String token, int dataVersion) async {
    String url = AppConfigs.getUrl(id, token, folder);
    await downloadFileAndSave(context, id, url, folder, folder, dataVersion);
  }

  Future<List<Reading>> getReading(String dir) async {
    var listReading = <Reading>[];
    final List<Map<String, dynamic>>? result = await getJsonData(dir, folder);
    if (result != null) {
      for (var item in result) {
        if (result.isNotEmpty) {
          listReading.add(Reading.fromJson(item));
        }
      }
    }
    return listReading;
  }

  Future<List<Word>> getWords(String dir) async {
    var listWord = <Word>[];
    final List<Map<String, dynamic>>? result =
        await getJsonData(dir, 'reading_vocabulary');
    if (result != null) {
      for (var item in result) {
        if (result.isNotEmpty) {
          listWord.add(Word.fromJson(item));
        }
      }
    }
    return listWord;
  }
}
