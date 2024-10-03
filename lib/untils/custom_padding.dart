import 'package:flutter/material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class CustomPadding {
  static EdgeInsets questionCardPadding(BuildContext context) {
    var isTablet = Resizable.isTablet(context);
    return EdgeInsets.only(
      top: Resizable.padding(context, 10),
      left: Resizable.padding(context, isTablet ? 30 :  15),
      right: Resizable.padding(context, isTablet ? 30 : 15),
    );
  }
}