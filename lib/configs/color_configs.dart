import 'package:flutter/material.dart';

const MaterialColor primaryColor = MaterialColor(0xff2C6E49, <int, Color>{
  50: Color(0xffd9ffe8),
  100: Color(0xffbdeacf),
  200: Color(0xffa1d5b6),
  300: Color(0xff84bf9e),
  400: Color(0xff68aa85),
  500: Color(0xff2C6E49),
  600: Color(0xff3b7c56),
  700: Color(0xff2a6341),
  800: Color(0xff19492c),
  900: Color(0xff083016),
});
const MaterialColor greyColor = MaterialColor(0xff5d60ef, <int, Color>{
  50: Color(0xfff5f5f5),
  100: Color(0xffd9d9d9),
  200: Color(0xffc8c8c8),
  300: Color(0xffd9d9d9),
  400: Color(0xffbdbdbd),
  500: Color(0xff727272),
  600: Color(0xff757575),
  700: Color(0xff676767),
  800: Color(0xff505050),
  900: Color(0xff392D2f),
});

const Color darkRedColor = Color(0xffB71C1C);
const Color darkGreenColor = Color(0xff33691E);
const Color greenColor = Color(0xff89BE5F);
const Color lightBrownColor = Color(0xffDF9B79);
const Color greyAccent= Color(0xffF5F5F5);
const Color darkGreyColor = Color(0xff686868);
const Color oldAnswer= Color(0xffe0e0e0);
const Color whiteColor = Color(0xffffffff);
const Color subTitleColor= Color(0xff565656);
const Color greyIconColor= Color(0xffC2C2C2);
const List<Color> lightGradientColor = [
  Color(0xffFFF5D8),
  Color(0xffFBE9B7)
];

const List<Color> primaryGradientColor = [
  Color(0xff2C6E49),
  Color(0xff3b7c56)
];
List<BoxShadow> itemShadow = [
  const BoxShadow(color: primaryColor, blurRadius: 4),
  BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: const Offset(0, 8),
      blurRadius: 4)
];



