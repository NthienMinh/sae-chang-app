import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';


class CustomScrollBar extends StatelessWidget {
   CustomScrollBar({super.key, required this.child});
  final scrollController = ScrollController();
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
        controller: scrollController,
        thickness: 5, //width of scrollbar
        thumbColor: primaryColor,
        thumbVisibility: true,
        trackVisibility: true,
        trackColor: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 15).copyWith(
      right: 8,
    ),
    radius: const Radius.circular(20),
    trackRadius:  const Radius.circular(20),//corner radius of scrollbar
    scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
    child: SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: child,
      ),
    ));
  }
}
