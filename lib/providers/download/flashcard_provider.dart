
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/models/skill_models/flash_card_model.dart';

import 'download_course_provider.dart';

class FlashCardProvider extends DownloadCourseProvider {
  FlashCardProvider._privateConstructor();

  static final FlashCardProvider instance =
  FlashCardProvider._privateConstructor();

  String folder = 'flashcard';

  Future downloadFile(BuildContext context, int id, String token, int dataVersion) async {
    String url = AppConfigs.getUrl(id, token, folder);
    await downloadFileAndSave(context, id, url, folder, folder, dataVersion);
  }

  Future<List<FlashCardModel>> getFlashcards(String dir) async {
    var listFlashcard = <FlashCardModel>[];
    final List<Map<String, dynamic>>? result = await getJsonData(dir,folder);
    if (result != null) {
      for (var item in result) {
        if (result.isNotEmpty) {
          listFlashcard.add(FlashCardModel.fromMap(item));
        }
      }
    }
    return listFlashcard;
  }
}