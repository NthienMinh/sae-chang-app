import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/models/skill_models/grammar.dart';

import 'download_course_provider.dart';

class GrammarProvider extends DownloadCourseProvider {
  GrammarProvider._privateConstructor();

  static final GrammarProvider instance = GrammarProvider._privateConstructor();

  String folder = 'grammar';

  Future downloadFile(BuildContext context, int id, String token, int dataVersion) async {
    String url =  AppConfigs.getUrl(id, token, folder);
    await downloadFileAndSave(context , id, url, folder,folder,dataVersion);
  }

  Future<List<Grammar>> getGrammars(String dir) async {
    var listGrammar = <Grammar>[];
    final List<Map<String, dynamic>>? result = await getJsonData(dir, folder);
    if (result != null) {
      for (var item in result) {
        if (result.isNotEmpty) {
          listGrammar.add(Grammar.fromJson(item));
        }
      }
    }
    return listGrammar;
  }
}
