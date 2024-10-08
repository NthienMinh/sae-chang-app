import 'package:flutter/material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout, tabletLayout;
  const ResponsiveLayout(
      {required this.mobileLayout,
        required this.tabletLayout,
        super.key});

  @override
  Widget build(BuildContext context) {
    if(Resizable.isTablet(context) ) {
      return tabletLayout;
    }
    else {
      return mobileLayout;
    }
  }
}