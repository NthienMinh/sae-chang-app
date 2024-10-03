import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class MyAppBar extends AppBar {
  MyAppBar(title, context,
      {fontColors = Colors.white,
      backgroundColor = primaryColor,
      double fontSize = 20,
      key,
      leading,
      actions,
        bottom,
      autoLeading = true})
      : super(
          key: key,
          leading: leading,
          actions: actions,
          centerTitle: true,
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: autoLeading,
          toolbarHeight: Resizable.size(context, 60),
          bottom: bottom,
          leadingWidth: Resizable.isTablet(context) ? 100 : null,
          iconTheme: IconThemeData(
              color: fontColors,
              size: Resizable.isTablet(context)
                  ? Resizable.font(context, 30)
                  : null),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(Resizable.size(context, 30)),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                color: fontColors,
                fontWeight: FontWeight.w700,
                fontSize: fontSize),
          ),
        );
}
