import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/dialogs.dart';
import 'package:sae_chang/widgets/refuse_access_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:app_settings/app_settings.dart';

class VoiceRecordCubit extends Cubit<List<File>> {
  VoiceRecordCubit( {Key? key, required this.context, required this.record}) : super([]);
  final BuildContext context;
  // final recorder = FlutterSoundRecorder();
  final AudioRecorder record;




  load(List<File> files) {
    emit(files);
  }

  clear(QuestionModel questionModel, String type) async {
    questionModel.answered = [];
   // await BaseSharedPreferences.savePracticeData(questionModel, type);
    emit([]);
  }

  removeRecord(
      File file, QuestionModel questionModel, PracticeBloc bloc, String type) async {
    List<String> listPath = [];
    for (var i in state) {
      listPath.add(i.path);
    }
    listPath.remove(file.path);
    questionModel.answered = listPath;
    bloc.add(UpdateEvent());
    //await BaseSharedPreferences.savePracticeData(questionModel, type);
    emit([...(state..remove(file))]);
  }

  pauseRecorder() async {
    // if (Platform.isAndroid) {
    await record.pause();
    // } else if (Platform.isIOS) {
    //   recorder.pauseRecorder();
    // }
  }
  resumeRecorder() async {
    // if (Platform.isAndroid) {
    await record.resume();
    // } else if (Platform.isIOS) {
    //   recorder.resumeRecorder();
    // }
  }

  Future<bool> checkPermission() async {
    return await record.hasPermission();
  }

  int startTime = 0;

  String recordFilePath = "";

  Future<bool> startRecord(String fileName) async {
    debugPrint("=============>path start ${state.length}");
    bool hasPermission = await checkPermission();
    if(!hasPermission && context.mounted) {
      Dialogs.showDialogCustom(
          context,
          false,
          RefuseAccessDialog(
            namePermission: AppText.txtPleaseGrantPermission.text,
            onIgnore: () {
              Navigator.pop(context);
            },
            onSetting: () async {
              Navigator.pop(context);
              // await Permission.microphone.request();
              await AppSettings.openAppSettings(
                  type: AppSettingsType.accessibility
              );

            },
          ));
      return false;
    } else {
      recordFilePath = (await getFilePath(fileName));
      // if (Platform.isAndroid) {
      await record.start(const RecordConfig(
        encoder: AudioEncoder.wav

      ), path: recordFilePath).onError((_, __) {
        debugPrint('error when record');
        File(recordFilePath).deleteSync();
      }).whenComplete(() {
        debugPrint('success');
      });
      // } else if (Platform.isIOS) {
      //   await recorder.startRecorder(
      //       toFile: recordFilePath,
      //       codec: Codec.mp3,
      // bitRate: 32000,
      // audioSource: AudioSource.defaultSource);
      // }
      return true;
    }
  }

  int get durationMilliseconds =>
      DateTime.now().millisecondsSinceEpoch - startTime;

  Future<String> getFilePath(String fileName) async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/$fileName.wav";
  }

  Future stopRecord(QuestionModel questionModel, PracticeBloc bloc, String type) async {
    await record.stop();
    debugPrint('=>>>>>> stopRecord${state.length}');

    final file = File(recordFilePath);
    debugPrint("=============>path stop $file");
    if(file.existsSync()) {
      emit([...state, file]);
      List<String> listPath = [];
      for (var i in state) {
        debugPrint(i.toString());
        listPath.add(i.path);
      }
      questionModel.answered = listPath;
      bloc.add(UpdateEvent());
      //BaseSharedPreferences.savePracticeData(questionModel, type);
    }
    else {
      Fluttertoast.showToast(msg: AppText.txtRecordError.text);
    }

  }
}


