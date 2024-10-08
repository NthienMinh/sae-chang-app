import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/models/skill_models/word.dart';
import 'package:sae_chang/providers/download/reading_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/services/download_controller.dart';


class ReadingCubit extends Cubit<int> {
  ReadingCubit(this.context, this.lessonId)
      : super(0);
  final BuildContext context;
  final int lessonId;
  final repo = ReadingProvider.instance;
  var listReading = <Reading>[];
  var listReadingVocabulary = <Word>[];

  int indexQuestion = 0;
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
        lessonId, "reading", course.first.dataVersion);
    if (context.mounted) {
      await repo.downloadFile(
          context, lessonId, token, course.first.dataVersion);
    }
    listReading = await repo.getReading(dir);
    listReadingVocabulary = await repo.getWords(dir);
    if (isClosed) return;
    emit(state + 1);
  }
}
