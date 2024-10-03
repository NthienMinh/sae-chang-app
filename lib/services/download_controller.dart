import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DownLoadController {
  static Future<String> getDownloadFolder(
      int id, String folder, int dataVersion) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    String dir = '';
    dir = '${appDocDir.path}/v_$dataVersion/${folder}_$id/';
    final Directory appDocDirFolder = Directory(dir);
    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  // static Future<String> getDirGk(String lessonId, String folder) async {
  //   final Directory appDocDirFolder = Directory(
  //       '${await CourseService.instance.createPrefix()}course_$lessonId/$folder/');
  //
  //   if (await appDocDirFolder.exists()) {
  //     return appDocDirFolder.path;
  //   } else {
  //     final Directory appDocDirNewFolder =
  //         await appDocDirFolder.create(recursive: true);
  //     return appDocDirNewFolder.path;
  //   }
  // }

  static Future<String> createDirectory(String dir) async {
    final Directory appDocDirFolder = Directory(dir);
    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }
}
