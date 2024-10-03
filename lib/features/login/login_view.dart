import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_button.dart';
import 'package:sae_chang/widgets/login_text_field.dart';
import 'package:simple_shadow/simple_shadow.dart';

class LoginView extends StatefulWidget {
  final TextEditingController passwordTextController;
  final TextEditingController emailTextController;

  const LoginView(
      {super.key,
      required this.passwordTextController,
      required this.emailTextController});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 20)),
      child: BlocProvider(
        create: (context) => ValidateTextFiledCubit(),
        child: BlocBuilder<ValidateTextFiledCubit, int>(
          builder: (context, state) {
            final cubit = context.read<ValidateTextFiledCubit>();
            return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical :Resizable.padding(context, 25), horizontal: Resizable.padding(context, 50)),
                      child: SimpleShadow(
                        color: primaryColor.withOpacity(0.1),
                        sigma: 2,
                        child: Image.asset(
                          'assets/images/img_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AutoSizeText("Dành riêng cho",
                        style: TextStyle(
                          color: primaryColor.shade700,
                          fontWeight: FontWeight.w800,
                          fontSize: Resizable.font(context, 28),
                        )),
                    AutoSizeText("Học viên Sae Chang",
                        style: TextStyle(
                          color: primaryColor.shade700,
                          fontWeight: FontWeight.w800,
                          fontSize: Resizable.font(context, 30),
                        )),
                    Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal:Resizable.padding(context, 5)),
                        child: Text(AppText.txtLetLogin.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 17),
                            ))),
                    SizedBox(height: Resizable.padding(context, 40)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          txt: widget.emailTextController,
                          text: AppText.txtEmail.text,
                          iconColor: greyColor.shade600,
                          isPassWord: false,
                          paddingHorizontal: 5,
                        ),
                        if (cubit.textEmailWrong.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                                top: Resizable.padding(context, 5),
                                left: Resizable.padding(context, 20)),
                            child: Text("* ${cubit.textEmailWrong}",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 12),
                                )),
                          ),
                        SizedBox(height: Resizable.padding(context, 10)),
                        CustomTextField(
                          txt: widget.passwordTextController,
                          text:  AppText.txtPassword.text,
                          iconColor: greyColor.shade600,
                          paddingHorizontal: 5,
                        ),
                        if (cubit.textPassWrong.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                                top: Resizable.padding(context, 5),
                                left: Resizable.padding(context, 20)),
                            child: Text("* ${cubit.textPassWrong}",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 12),
                                )),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: Resizable.padding(context, 20),
                          left: Resizable.padding(context, 100),
                          right: Resizable.padding(context, 100)),
                      child: CustomButton(
                        title: AppText.txtLogin.text,
                        onTap: () async {
                          if (widget.emailTextController.text.isEmpty) {
                            cubit.updateEmail(AppText.txtEmailNotEmpty.text);
                            return;
                          } else {
                            cubit.updateEmail('');
                          }

                          if (widget.passwordTextController.text.isEmpty) {
                            cubit.updatePass(AppText.txtPasswordNotEmpty.text);
                            return;
                          } else {
                            cubit.updatePass('');
                          }

                          final res = await FireBaseProvider.instance.login(
                              widget.emailTextController.text.toLowerCase(),
                              widget.passwordTextController.text,
                              context);

                          if (res.isNotEmpty) {
                            debugPrint(res);
                            if (res == "wrong-password") {
                              widget.passwordTextController.text = "";
                              cubit.updatePass(AppText.txtPasswordInvalid.text);
                              return;
                            } else if (res == "invalid-email") {
                              cubit.updateEmail(AppText.txtEmailInvalid.text);
                              return;
                            } else {
                              cubit.updateEmail(AppText.txtUserNotFound.text);
                              return;
                            }
                          } else {
                            cubit.updatePass('');
                            cubit.updateEmail('');
                          }
                        },
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        height: 45,
                        fontSize: 15,
                      ),
                    ),
                    // Center(
                    //   child: TextButton(
                    //       onPressed: () {
                    //         Navigator.of(context, rootNavigator: true)
                    //             .pushNamed(Routes.forgotPass);
                    //       },
                    //       child: Text(
                    //         AppText.txtForgotPassword.text,
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: Resizable.size(context, 15),
                    //             color: Colors.black),
                    //       )),
                    // )
                  ],
                ));
          },
        ),
      ),
    );
  }
}

class ValidateTextFiledCubit extends Cubit<int> {
  ValidateTextFiledCubit() : super(0);

  String textEmailWrong = '';
  String textPassWrong = '';

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  updateEmail(String value) {
    textEmailWrong = value;
    emitState();
  }

  updatePass(String value) {
    textPassWrong = value;
    emitState();
  }
}
