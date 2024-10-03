import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController txt;
  final Color iconColor;
  final String text;
  final PasswordVisibleCubit _passwordVisibleCubit = PasswordVisibleCubit();
  final bool isPassWord;
  final bool enableEditing;
  final String Function(String?)? validator;
  final double paddingHorizontal;

  CustomTextField(
      {required this.txt,
        required this.text,
        super.key,
        required this.iconColor,
        this.enableEditing = true,
        this.paddingHorizontal = 0,
        this.validator,
        this.isPassWord = true});

  @override
  Widget build(BuildContext context) => BlocBuilder<PasswordVisibleCubit, bool>(
      bloc: _passwordVisibleCubit,
      builder: (BuildContext context, isVisible) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000), boxShadow: itemShadow),
          child: BlocProvider(
            create: (context) => TrackTextCubit()..update(txt.text),
            child: BlocBuilder<TrackTextCubit, String>(
              builder: (context, value) {
                final cubit = context.read<TrackTextCubit>();
                return TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    enabled: enableEditing,
                    controller: txt,
                    onChanged: (value) {
                      cubit.update(value);
                    },
                    obscureText: isPassWord ? !isVisible : false,
                    validator: (value) {
                      if (validator == null) {
                        return null;
                      }
                      return validator!(value!);
                    },
                    style: TextStyle(
                        color: iconColor.withOpacity(0.9),
                        fontSize: Resizable.font(context, 18),
                        fontWeight: FontWeight.w600),
                    cursorColor: iconColor,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: text,
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 18),
                        color: subTitleColor.withOpacity(0.6),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20),
                      ),
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: Resizable.size(context, 40),
                              margin: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 5)),
                              padding: EdgeInsets.only(
                                  left: Resizable.padding(context, 10)),
                              child: Image.asset(
                                color: primaryColor,
                                'assets/icons/ic_${isPassWord ? 'lock' : 'person'}.png',
                                height: Resizable.size(context, 20),
                              )),
                          SizedBox(
                            width: Resizable.padding(context, 10),
                            height: Resizable.padding(context, 55),
                          ),
                        ],
                      ),
                      labelStyle: TextStyle(
                          fontSize: Resizable.font(context, 18),
                          color: Colors.grey.shade900),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide.none,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: !isPassWord
                          ? value.isEmpty
                          ? null
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              cubit.update('');
                              txt.clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.clear,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                          : IconButton(
                        onPressed: _passwordVisibleCubit.change,
                        splashColor: Colors.transparent,
                        icon: isPassWord
                            ? Icon(
                            !isVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: !isVisible
                                ? greyIconColor
                                : Colors.grey)
                            : Container(),
                      ),
                    ));
              },
            ),
          ),
        );
      });
}

class PasswordVisibleCubit extends Cubit<bool> {
  PasswordVisibleCubit() : super(false);

  change() {
    emit(!state);
  }
}

class TrackTextCubit extends Cubit<String> {
  TrackTextCubit() : super('');

  update(String value) {
    emit(value);
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController txt;
  final Color iconColor;
  final String text;
  final PasswordVisibleCubit _passwordVisibleCubit = PasswordVisibleCubit();
  final bool enableEditing;
  final String Function(String?)? validator;
  PasswordTextField({
    required this.txt,
    required this.text,
    super.key,
    required this.iconColor,
    this.enableEditing = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => BlocBuilder<PasswordVisibleCubit, bool>(
      bloc: _passwordVisibleCubit,
      builder: (BuildContext context, isVisible) {
        return SizedBox(
          height: Resizable.size(context, 55),
          child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              enabled: enableEditing,
              controller: txt,
              obscureText: !isVisible,
              validator: (value) {
                if (validator == null) {
                  return null;
                }
                return validator!(value!);
              },
              style: TextStyle(
                  color: iconColor.withOpacity(0.9),
                  fontSize: Resizable.font(context, 18),
                  fontWeight: FontWeight.w600),
              cursorColor: primaryColor,
              decoration: InputDecoration(
                fillColor: const Color(0xffFFFDF8),
                filled: true,
                hintText: text,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: Resizable.font(context, 18),
                  color: Colors.black54,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                ),
                constraints:
                    BoxConstraints(maxHeight: Resizable.size(context, 30)),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: Resizable.size(context, 40),
                        margin: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 5)),
                        padding: EdgeInsets.only(
                            left: Resizable.padding(context, 10)),
                        child: Image.asset(
                          'assets/icons/ic_lock.png',
                          color: primaryColor,
                          height: Resizable.size(context, 25),
                        )),
                  ],
                ),
                labelStyle: TextStyle(
                    fontSize: Resizable.font(context, 18),
                    color: Colors.grey.shade900),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: const BorderSide(color: primaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: const BorderSide(color: primaryColor, width: 1),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(1000),
                ),
                suffixIcon: IconButton(
                  onPressed: _passwordVisibleCubit.change,
                  icon: Icon(
                      !isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: iconColor),
                ),
              )),
        );
      });
}

class EmailTextField extends StatelessWidget {
  final TextEditingController txt;
  final Color iconColor;
  final String text;
  final bool enableEditing;
  final String Function(String?)? validator;
  const EmailTextField({
    required this.txt,
    required this.text,
    super.key,
    required this.iconColor,
    this.enableEditing = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: Resizable.size(context, 55),
    child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        enabled: enableEditing,
        controller: txt,
        obscureText: false,
        validator: (value) {
          if (validator == null) {
            return null;
          }
          return validator!(value!);
        },
        style: TextStyle(
            color: iconColor.withOpacity(0.9),
            fontSize: Resizable.font(context, 18),
            fontWeight: FontWeight.w600),
        cursorColor: primaryColor,
        decoration: InputDecoration(
          fillColor: const Color(0xffFFFDF8),
          filled: true,
          hintText: text,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: Resizable.font(context, 18),
            color: Colors.black54,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
          ),
          constraints:
          BoxConstraints(maxHeight: Resizable.size(context, 30)),
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: Resizable.size(context, 40),
                  margin: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 5)),
                  padding: EdgeInsets.only(
                      left: Resizable.padding(context, 10)),
                  child: Image.asset(
                    'assets/icons/ic_person.png',
                    color: primaryColor,
                    height: Resizable.size(context, 25),
                  )),
            ],
          ),
          labelStyle: TextStyle(
              fontSize: Resizable.font(context, 18),
              color: Colors.grey.shade900),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1000),
            borderSide: const BorderSide(color: primaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1000),
            borderSide: const BorderSide(color: primaryColor, width: 1),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 1),
            borderRadius: BorderRadius.circular(1000),
          ),
        )
    ),
  );
}