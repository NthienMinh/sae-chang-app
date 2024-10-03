import 'package:flutter/material.dart';
import 'package:sae_chang/features/login/login_view.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordTextController = TextEditingController();

  final _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: MyAppBar(AppText.txtLogin.text, context),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(
                    context, Resizable.isTablet(context) ? 20 : 0)),
            child: LoginView(
              passwordTextController: _passwordTextController,
              emailTextController: _emailTextController,
            ),
          ),
        ));
  }
}
