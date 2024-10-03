import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/configs/prefKeys_configs.dart';
import 'package:sae_chang/models/base_model/user_model.dart';
import 'package:sae_chang/shared_preferences.dart';


class FirebaseAuthentication {
  FirebaseAuthentication._privateConstructor();
  static final FirebaseAuthentication instance =
  FirebaseAuthentication._privateConstructor();

  Future<String> logInUser(
      String email,
      String password,
      ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return "true";
    } on FirebaseAuthException catch (e) {
      if (AppConfigs.isRunningDebug) {
        return e.message!;
      }
      return e.code;
    }
  }

  Future<void> logOutUser() async {
    final auth = FirebaseAuth.instance;
    await auth.signOut();
  }


  Future<bool> changePassword(
      String email, String oldPass, String newPass) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    bool res = false;
    var cred = EmailAuthProvider.credential(email: email, password: oldPass);

    try {
      await currentUser!.reauthenticateWithCredential(cred);
      await currentUser.updatePassword(newPass);
      Fluttertoast.showToast(msg: 'Đổi mật khẩu thành công');
      res = true;
    } catch (error) {
      debugPrint('=>>>>>>>>>>>>>error: $error');
      Fluttertoast.showToast(msg: 'Mật khẩu cũ không chính xác! Thử lại');
    }
    return res;
  }

  Future<String> uploadImageAndGetUrl(Uint8List data, String folder) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final ref = FirebaseStorage.instance.ref().child('$folder/$now');
    await ref.putData(data, SettableMetadata(contentType: '.png'));
    return await ref.getDownloadURL();
  }

  Future<bool> saveLogin(UserModel user) async {
    await BaseSharedPreferences.setIntValue(PrefKeyConfigs.userId, user.id);
    await BaseSharedPreferences.setString(PrefKeyConfigs.email, user.email);
    await BaseSharedPreferences.setString('isLogin', 'true');
    return true;
  }
}