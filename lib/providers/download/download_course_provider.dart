import 'dart:convert';

import 'package:archive/archive.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/services/download_controller.dart';
import 'package:sae_chang/services/progress_service.dart';
import 'package:sae_chang/untils/dialogs.dart';


class DownloadResultFile {
  final File? file;
  final String directory;

  DownloadResultFile({this.file, required this.directory});
}

class DownloadCourseProvider {
  Future<DownloadResultFile> _downloadZipFile(
      BuildContext context,
      int id,
      String url,
      String folder,
      String type,
      int dataVersion,
      int permitPop) async {
    debugPrint('=>>>>>>>>> url : $url');
    var directory =
        await DownLoadController.getDownloadFolder(id, folder, dataVersion);

    var file = File(type == "test"
        ? '${directory}test_$id.zip'
        : '$directory$folder.zip');
    if (await file.exists()) {
      return DownloadResultFile(
          file: file,
          directory: directory); // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        ProgressService? dialog;
        if (context.mounted) {
          dialog = ProgressService(context, false, 'download');
        }
        Response response =
            await dio.get(url, onReceiveProgress: (received, total) async {
          if (total != -1) {
            debugPrint('=>>>>${received * 100 ~/ total}%');
            var progress = (((received / total) * 100).toDouble());
            dialog!.update(progress);
          }
        }, options: Options(responseType: ResponseType.bytes));
        if (response.statusCode == 200) {
          file.writeAsBytesSync(response.data);
          debugPrint('=>>>>>>>>>>>>> File Saved: ${file.path}');
          return DownloadResultFile(file: file, directory: directory);
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          Dialogs.showErrorConnectDialog(context, permitPop);
        }
        debugPrint('Lỗi khi tải xuống tệp: $e');
        return DownloadResultFile(file: null, directory: directory);
      }
      return DownloadResultFile(file: null, directory: directory);
    }
  }


  Future<void> downloadFileAndSave(BuildContext context, int id,
      String url, String folder, String type,int dataVersion,
      {int permitPop = 0}) async {

    var zippedFile = await _downloadZipFile(
        context, id, url, folder, type,dataVersion, permitPop);
    if (zippedFile.file == null) return;
    var bytes = zippedFile.file!.readAsBytesSync();
    var archive =
        ZipDecoder().decodeBytes(bytes, password: AppConfigs.passwordUnzip);

    Functions.logDebug('zipDirectory: ${zippedFile.directory}');
    for (final file in archive) {
      if (file.isFile) {
        final data = file.content as List<int>;
        final filePath = '${zippedFile.directory}${file.name.trim()}';
        if (!File(filePath).existsSync()) {
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        }
      }
    }
  }
  //
  // Future<void> downloadFileAndSaveTestLocal(
  //     BuildContext context, String url, String testId) async {
  //   var zippedFile = await _downloadTestLocalFile(context, url, testId);
  //   if (zippedFile.file == null) return;
  //   var bytes = zippedFile.file!.readAsBytesSync();
  //   var archive =
  //       ZipDecoder().decodeBytes(bytes, password: AppConfigs.passwordUnzip);
  //   for (final file in archive) {
  //     if (file.isFile) {
  //       final data = file.content as List<int>;
  //       final filePath = '${zippedFile.directory}${file.name.trim()}';
  //       if (!File(filePath).existsSync()) {
  //         File(filePath)
  //           ..createSync(recursive: true)
  //           ..writeAsBytesSync(data);
  //       }
  //     }
  //   }
  // }
  //
  Future<List<Map<String, dynamic>>?> getJsonData(String dir,String folder) async {

    debugPrint('$dir$folder.json');

    var file = File('$dir$folder.json');
    if (file.existsSync()) {
      final jsonData = await file.readAsString();
      return List<Map<String, dynamic>>.from(json.decode(jsonData));
    }
    return null;
  }

  String getUrlImageById(String id, [String path = '', String dir = '']) {
    var p = path.isNotEmpty ? path : dir;

    Functions.logDebug('dirExist:${File('$p/$id.png').existsSync()}');
    if (File('$p/$id.png').existsSync()) {
      return File('$p/$id.png').path;
    } else if (File('$p/$id.jpg').existsSync()) {
      return File('$p/$id.jpg').path;
    }
    return '';
  }

  String getUrlAudioById(String id,String dir, [String path = '']) {
    var p = path.isNotEmpty ? path : dir;

    Functions.logDebug('dirExist:${File('$p$id.mp3').existsSync()}');
    if (File('$p$id.mp3').existsSync()) {
      return File('$p$id.mp3').path;
    } else if (File('$p$id.oga').existsSync()) {
      return File('$p$id.oga').path;
    }
    return '';
  }
}
