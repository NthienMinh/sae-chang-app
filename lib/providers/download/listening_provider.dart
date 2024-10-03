

import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/models/skill_models/lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'download_course_provider.dart';

class ListeningProvider extends DownloadCourseProvider {
  ListeningProvider._privateConstructor();

  static final ListeningProvider _instance = ListeningProvider._privateConstructor();

  static ListeningProvider get instance => _instance;


  String folder = 'listening';

  downloadFile(BuildContext context, int id, String token, int dataVersion) async {
    String url =  AppConfigs.getUrl(id, token, folder);
    await downloadFileAndSave(context , id, url, folder,folder,dataVersion);
  }
  Future<List<Lesson>> getLessons(String dir) async {
    var listLesson = <Lesson>[];
    final List<Map<String, dynamic>>? result = await getJsonData(dir,folder);
    if(result != null) {
      for (var item in result) {
        if (result.isNotEmpty) {
          listLesson.add(Lesson.fromJson(item));
        }
      }
    }
    return listLesson;
  }

  Future setBlur(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfigs.KEY_LISTENING_BLUR, value);
  }
  Future<bool> getBlur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isBlur;
    isBlur = prefs.getBool(AppConfigs.KEY_LISTENING_BLUR) ?? true;
    setBlur(isBlur);
    return isBlur;
  }
  Future setTranslate(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfigs.KEY_LISTENING_TRANSLATE, value);
  }
  Future<bool> getTranslate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTranslate;
    isTranslate = prefs.getBool(AppConfigs.KEY_LISTENING_TRANSLATE) ?? true;
    setTranslate(isTranslate);
    return isTranslate;
  }
  Future setPhonetic(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfigs.KEY_LISTENING_PHONETIC, value);
  }
  Future<bool> getPhonetic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPhonetic;
    isPhonetic = prefs.getBool(AppConfigs.KEY_LISTENING_PHONETIC) ?? false;
    setPhonetic(isPhonetic);
    return isPhonetic;
  }

  Future setFurigana(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfigs.KEY_LISTENING_FURIGANA, value);
  }
  Future<bool> getFurigana() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFurigana;
    isFurigana = prefs.getBool(AppConfigs.KEY_LISTENING_FURIGANA) ?? false;
    setFurigana(isFurigana);
    return isFurigana;
  }
}