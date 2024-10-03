import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class AppBarTemplate extends AppBar {
  AppBarTemplate(
    title,
    context, {
    key,
    actions = const <Widget>[],
    titleColor = Colors.black,
    double super.elevation = 5,
    super.bottom,
  }) : super(
            key: key,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: primaryColor,
                size: Resizable.isTablet(context)
                    ? Resizable.font(context, 25)
                    : null),
            centerTitle: true,
            toolbarHeight: Resizable.size(context, 80),
            actions: actions,
            leadingWidth: Resizable.isTablet(context) ? 100 : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: Resizable.font(
                          context, Resizable.isTablet(context) ? 20 : 19),
                      color: titleColor,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ));
}

class AppBarTemplateTwoTitle extends AppBar {
  AppBarTemplateTwoTitle(
    title1,
    title2,
    context, {
    key,
    actions = const <Widget>[],
    titleColor1 = primaryColor,
    titleColor2 = Colors.black,
    double super.elevation = 5,
    super.bottom,
  }) : super(
            key: key,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: primaryColor,
                size: Resizable.isTablet(context)
                    ? Resizable.font(context, 25)
                    : null),
            centerTitle: true,
            toolbarHeight: Resizable.size(context, 80),
            actions: actions,
            leadingWidth: Resizable.isTablet(context) ? 100 : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title1,
                  style: TextStyle(
                      fontSize: Resizable.font(
                          context, Resizable.isTablet(context) ? 14 : 12),
                      color: titleColor1,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  title2,
                  style: TextStyle(
                      fontSize: Resizable.font(
                          context, Resizable.isTablet(context) ? 20 : 19),
                      color: titleColor2,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ));
}
