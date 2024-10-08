import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/models/skill_models/grammar.dart';
import 'package:sae_chang/providers/download/grammar_provider.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/services/download_controller.dart';

class GrammarCubit extends Cubit<int> {
  final repo = GrammarProvider.instance;

  GrammarCubit(this.context, this.lessonId) : super(0);
  final BuildContext context;
  final int lessonId;
  List<Grammar> listGrammars = [];

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
        lessonId, "grammar", course.first.dataVersion);
    if (context.mounted) {
      await repo.downloadFile(
          context, lessonId, token, course.first.dataVersion);
    }
    listGrammars = await repo.getGrammars(dir);
    if (isClosed) return;
    emit(state+1);
  }

}
