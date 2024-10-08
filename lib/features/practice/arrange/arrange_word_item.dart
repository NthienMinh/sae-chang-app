
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ArrangeWordItem extends StatelessWidget {
  const ArrangeWordItem(
      {super.key, required this.text, required this.isChoose});

  final String text;
  final bool isChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: Resizable.size(context, 45)),
        padding: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 10),
          horizontal: Resizable.padding(context, 10),
        ),
        decoration: BoxDecoration(
          color: isChoose ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(Resizable.size(context, 50)),
          border: Border.all(width: 0.5, color: primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SplitTextCustom(
              text: text.trim(),
              phoneticSize: 10,
              kanjiFW: FontWeight.w600,
              kanjiColor: isChoose ? whiteColor : primaryColor,
              phoneticColor: isChoose ? whiteColor : Colors.black,
              isSelected: isChoose,
              kanjiSize: 16)
        ]));
  }
}

class ArrangeWordItemV1 extends StatelessWidget {
  const ArrangeWordItemV1(
      {super.key, required this.text, required this.isChoose});

  final String text;
  final bool isChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Resizable.size(context, 60),
        width: Resizable.size(context, 60),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isChoose ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(Resizable.size(context, 10)),
          border: Border.all(width: 0.5, color: primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text.trim(),
          style: TextStyle(
              color: !isChoose ? primaryColor : Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: 'GenShinGothic',
              fontSize: Resizable.font(context, 30)),
        ));
  }
}