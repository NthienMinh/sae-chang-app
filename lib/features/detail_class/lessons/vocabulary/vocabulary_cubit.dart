import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/models/skill_models/word.dart';
import 'package:sae_chang/providers/download/vocabulary_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/services/download_controller.dart';

class VocabularyCubit extends Cubit<int> {
  VocabularyCubit(this.context, this.lessonId) : super(0);
  final BuildContext context;
  final int lessonId;
  List<Word> listWords = [];
  final repo = VocabularyProvider.instance;
  String dir = "";
  getData() async {
    await getDataDownload();
  }

  getDataDownload() async {
    String token = '';

    var lesson = await FireBaseProvider.instance.getLessonById(lessonId);

    var course =
        await FireBaseProvider.instance.getCourseByIds([lesson.courseId]);
    token = course.first.dataToken;

    String dir = await DownLoadController.getDownloadFolder(
        lessonId, "vocabulary", course.first.dataVersion);

    this.dir = dir;


    if (context.mounted) {
      await repo.downloadFile(
          context, lessonId, token, course.first.dataVersion);
    }
    listWords = await repo.getWords(dir);
    if (isClosed) {
      return;
    }
    emit(state + 1);
  }
}
