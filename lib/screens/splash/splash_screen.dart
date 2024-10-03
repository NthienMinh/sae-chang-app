import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/prefKeys_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/shared_preferences.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:simple_shadow/simple_shadow.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    applicationInitialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
              padding: EdgeInsets.all(Resizable.padding(context, 50)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleShadow(
                    color: primaryColor.withOpacity(0.1),
                    sigma: 2,
                    child: Image.asset(
                      'assets/images/img_logo.png',
                      fit: BoxFit.cover,
                      // height: Resizable.size(context, 160),
                    ),
                  ),
                ],
              )),
        ));
  }

  void applicationInitialize(BuildContext context) async {
    await DirectoryAppService.instance.init();
    await Future.delayed(const Duration(milliseconds: 1000));
    final user = FirebaseAuth.instance.currentUser;
    var email = await BaseSharedPreferences.getString(PrefKeyConfigs.email);
    var currentLevel =
        await BaseSharedPreferences.getString(PrefKeyConfigs.currentLevel);
    // if (context.mounted) {
    //   if (currentLevel.isEmpty) {
    //     Navigator.of(context, rootNavigator: true)
    //         .pushNamedAndRemoveUntil(Routes.chooseLevel, (route) => false);
    //     return;
    //   }
    //
    //   if (currentLevel.contains("HSK")) {
    //     Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
    //         Routes.home, (route) => false,
    //         arguments: {'level': currentLevel});
    //     return;
    //   } else if (user != null && email.isNotEmpty) {
    //     Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
    //         Routes.home, (route) => false,
    //         arguments: {'level': currentLevel});
    //     return;
    //   } else {
    //     Navigator.of(context, rootNavigator: true)
    //         .pushNamedAndRemoveUntil(Routes.chooseLevel, (route) => false);
    //     return;
    //   }
    // }
    if(context.mounted){
      if (user != null && email.isNotEmpty) {
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            Routes.home, (route) => false,
            arguments: {'level': AppText.txtHanNguSaeChang.text});
        return;
      }else{
        Navigator.of(context, rootNavigator: true).pushNamed(
          Routes.login,
        );
      }
    }
  }
}
