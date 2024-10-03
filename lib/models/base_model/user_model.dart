import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email, location, name, phone, code, status, avt, note, device;
  final List<dynamic> roles;
  final int id;

  const UserModel(
      {required this.email,
      required this.roles,
      required this.id,
      required this.location,
      required this.name,
      required this.phone,
      required this.note,
      required this.status,
      required this.code,
      required this.avt,
      required this.device});

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        email: data["email"] ?? "",
        roles: data["roles"] ?? [],
        id: data['user_id'] ?? 999999999999999,
        location: data['location'] ?? "Việt Nam",
        name: data['name'] ?? "",
        phone: data['phone'] ?? "",
        note: data['note'] ?? "",
        status: data['status'] ?? "normal",
        code: data['code'] ?? "",
        avt: data['avt'] ?? "",
        device: data['device'] ?? "");
  }

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
      email: json["email"],
      roles: json["roles"],
      id: json['user_id'],
      location: json['location'] ?? "Việt Nam",
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      note: json['note'] ?? "",
      status: json['status'] ?? "normal",
      code: json['code'] ?? "",
      avt: json['avt'] ?? "",
      device: json['device'] ?? "");
}
