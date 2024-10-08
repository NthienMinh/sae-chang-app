import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';


class MatchWordItem extends StatelessWidget {
  const MatchWordItem({super.key, required this.text, required this.isChoose, required this.type, required this.isBigger, required this.maxWidth});
final String text;
final bool isChoose;
final bool isBigger;
final String type;
final double maxWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
            minHeight:
            Resizable.size(context, 45) ,

        ),
        width:  Resizable.size(context, isBigger ? 180 > maxWidth ? maxWidth : 180 : 120),
        margin: EdgeInsets.symmetric(
            vertical: Resizable.padding(
                context, 5)),
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(
                context, 10),
            vertical: Resizable.padding(
                context, 10)),
        decoration: BoxDecoration(
          color: !isChoose
              ? type == 'B' ? Colors.grey.shade100 : Colors.white
              : primaryColor,
          borderRadius: BorderRadius.circular(
              Resizable.size(context, 7)),
          border: Border.all(
              width: 1, color:primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
            child: SplitTextCustom(
                text: text.trim(),
                phoneticSize: 10,
                kanjiFW: FontWeight.w600,
                kanjiColor: !isChoose ? Colors.black : Colors.white,
                phoneticColor: !isChoose ? Colors.black : Colors.white,
                kanjiSize: 16)
        ));
  }
}
