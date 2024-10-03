import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserClassModel {
  final int id, classId, userId, dateCreate, lastTimeChange;
  final String status, type, attitude, ability;

  UserClassModel(
      {required this.classId,
      required this.id,
      required this.userId,
      required this.lastTimeChange,
      required this.dateCreate,
      required this.type,
      required this.attitude,
      required this.ability,
      required this.status});

  factory UserClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserClassModel(
      classId: data['class_id'] ?? -1,
      id: data['id'] ?? -1,
      userId: data['user_id'] ?? -1,
      dateCreate: data['date_create'] ?? 0,
      lastTimeChange: data['last_change'] ?? 0,
      type: data['type'] ?? 'student',
      attitude: data['attitude'] ?? 'A',
      ability: data['ability'] ?? 'A',
      status: data['status'] ?? 'InProgress',
    );
  }

  factory UserClassModel.fromJson(Map<String, dynamic> jsonData) {
    return UserClassModel(
      classId: jsonData['class_id'] ?? -1,
      id: jsonData['id'] ?? -1,
      userId: jsonData['user_id'] ?? -1,
      dateCreate: jsonData['date_create'] ?? 0,
      lastTimeChange: jsonData['last_change'] ?? 0,
      type: jsonData['type'] ?? 'student',
      attitude: jsonData['attitude'] ?? 'A',
      ability: jsonData['ability'] ?? 'A',
      status: jsonData['status'] ?? 'InProgress',
    );
  }

  static Map<String, dynamic> toMap(UserClassModel userClass) => {
        'class_id': userClass.classId,
        'id': userClass.id,
        'user_id': userClass.userId,
        'date_create': userClass.dateCreate,
        'last_change': userClass.lastTimeChange,
        'type': userClass.type,
        'attitude': userClass.attitude,
        'ability': userClass.ability,
        'status': userClass.status
      };

  static String encode(List<UserClassModel> userClasses) => json.encode(
        userClasses
            .map<Map<String, dynamic>>(
                (userClass) => UserClassModel.toMap(userClass))
            .toList(),
      );

  static List<UserClassModel> decode(String userClasses) =>
      (json.decode(userClasses) as List<dynamic>)
          .map<UserClassModel>((item) => UserClassModel.fromJson(item))
          .toList();
}
