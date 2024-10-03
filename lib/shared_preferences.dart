import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configs/prefKeys_configs.dart';
import 'models/base_model/question_model.dart';

class BaseSharedPreferences {
  BaseSharedPreferences._();

  static Future<bool> setString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(key) ?? '';
    return value;
  }

  static Future<bool> setDoubleValue(String key, double value) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setDouble(key, value);
  }

  static Future<double?> getDoubleValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getDouble(key);
    return value;
  }

  static Future<bool> setIntValue(String key, int value) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setInt(key, value);
  }

  static Future<int?> getIntValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getInt(key);
    return value;
  }

  static Future<void> saveJsonToPrefs(
      Map<String, dynamic> json, String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(json);
      await prefs.setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> removeJsonToPref(String key) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  static Future<Map<String, dynamic>?> getJsonFromPrefs(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return json;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  static Future<String> getKey(
      String type, int id, int result, String temp) async {
    var key = '${type}_${id}_result_${result}_$temp';
    return key;
  }

  static Future<void> savePracticeData(
      QuestionModel questionModel, String type, int id, int resultId) async {
    var userId = await BaseSharedPreferences.getIntValue(PrefKeyConfigs.userId);

    var keySaved = await getKey(type, id, resultId, 'practice');

    Map<String, dynamic>? savedData =
        await BaseSharedPreferences.getJsonFromPrefs(keySaved);
    List<Map<String, dynamic>> listData = [];
    if (savedData != null) {
      final myJson = {
        'questionId': questionModel.id,
        'answer': questionModel.answered,
        'type': questionModel.questionType,
        'answerState': [1, 5, 44].contains(questionModel.questionType)
            ? questionModel.answerState
            : [],
      };
      for (var i in savedData['data']) {
        listData.add(i);
      }
      bool isNew = true;
      for (var i in listData) {
        if (i['questionId'] == questionModel.id) {
          listData[listData.indexOf(i)] = myJson;
          isNew = false;
          break;
        }
      }
      if (isNew) {
        listData.add(myJson);
      }
    } else {
      final myJson = {
        'questionId': questionModel.id,
        'answer': questionModel.answered,
        'type': questionModel.questionType,
        'answerState': [1, 5, 44].contains(questionModel.questionType)
            ? questionModel.answerState
            : [],
      };
      listData.add(myJson);
    }

    final saveJson = {
      'id': id,
      'type': type,
      'user_id': userId,
      'data': listData,
    };
    await BaseSharedPreferences.saveJsonToPrefs(saveJson, keySaved);
  }
}

class SharePreferencesListProvider {
  SharePreferencesListProvider._privateConstructor();

  static final SharePreferencesListProvider _instance =
      SharePreferencesListProvider._privateConstructor();

  static SharePreferencesListProvider get instance => _instance;

  Future insert(type, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(type) ?? [];
    if (!savedList.contains(value)) {
      savedList.add(value);
    }
    await prefs.setStringList(type, savedList);
  }

  Future remove(type, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(type) ?? [];
    if (savedList.contains(value)) {
      savedList.remove(value);
    }
    await prefs.setStringList(type, savedList);
  }

  Future<bool> checkExist(type, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(type) ?? [];
    if (savedList.contains(value)) {
      return true;
    }
    return false;
  }

  Future<List<String>> getList(type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(type) ?? [];
    return savedList;
  }

  Future setListString(type, List<String> savedList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(type, savedList);
  }
}
