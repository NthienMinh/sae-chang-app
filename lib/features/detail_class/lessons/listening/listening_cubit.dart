import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/models/skill_models/lesson.dart';
import 'package:sae_chang/providers/download/listening_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/services/download_controller.dart';

class ListeningCubit extends Cubit<int> {
  ListeningCubit(this.context, this.lessonId) : super(0);

  final BuildContext context;
  final int lessonId;

  final repo = ListeningProvider.instance;
  List<Lesson>? listLessons;

  getData() async {
    await getDataDownload();
  }

  getDataDownload() async {
    String token = '';

    var lesson = await FireBaseProvider.instance.getLessonById(lessonId);

    var course =
        await FireBaseProvider.instance.getCourseByIds([lesson.courseId]);

    String dir = await DownLoadController.getDownloadFolder(
        lessonId, "listening", course.first.dataVersion);
    token = course.first.dataToken;

    if (context.mounted) {
      await repo.downloadFile(
          context, lessonId, token, course.first.dataVersion);
    }
    listLessons = await repo.getLessons(dir);

    if (isClosed) return;
    emit(state + 1);
  }
}
