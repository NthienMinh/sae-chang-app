import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class ReusableTextField extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isPasswordType;
  final bool enableEditing;
  final TextEditingController? controller;
  final Color cursorColor;
  final Color iconColor;
  final bool isNumber;
  final double height;

  const ReusableTextField(this.text, this.icon, this.isPasswordType,
      {required this.controller,
      this.enableEditing = true,
      this.cursorColor = Colors.white,
      this.iconColor = Colors.white70,
      this.isNumber = false,
      this.height = 50,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Resizable.size(context, height),
      decoration: BoxDecoration(
        color: const Color(0xffF4F6FD),
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.circular(Resizable.size(context, 100)),
      ),
      child: TextField(
        enabled: enableEditing,
        controller: controller,
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: cursorColor,

        style: TextStyle(color: iconColor.withOpacity(0.9), fontSize: Resizable.font(context, 18)),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding:  EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
            child: Icon(
              icon,
              size: Resizable.size(context, 25),
              color: iconColor,
            ),
          ),
          labelText: text,
          labelStyle: TextStyle(color: iconColor.withOpacity(0.9)),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          //fillColor: iconColor.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
        ),
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
            : [],
        keyboardType: !isNumber
            ? isPasswordType
                ? TextInputType.visiblePassword
                : TextInputType.emailAddress
            : const TextInputType.numberWithOptions(
                decimal: true,
              ),
      ),
    );
  }
}
