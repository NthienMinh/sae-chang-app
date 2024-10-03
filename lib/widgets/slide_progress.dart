import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class SlideProgress extends StatelessWidget {
  const SlideProgress({
    super.key,
    required this.percent,
    required this.text,
    required this.isRed,
  });

  final double percent;
  final String text;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearPercentIndicator(
            padding: EdgeInsets.zero,
            animation: true,
            lineHeight: Resizable.size(context, 5),
            animationDuration: 2500,
            percent: percent,
            center: const SizedBox(),
            barRadius: const Radius.circular(1000),
            backgroundColor: !isRed
                ? Colors.white.withOpacity(0.5)
                : primaryColor.withOpacity(0.5),
            progressColor: !isRed ? Colors.white : primaryColor,
          ),
        ),
        if (text.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 5)),
            //width: Resizable.size(context, 40),
            alignment: Alignment.center,
            child: AutoSizeText(
              text,
              maxLines: 1,
              style: TextStyle(
                  height: 1,
                  fontSize: Resizable.font(context, 14),
                  fontWeight: FontWeight.w600,
                  color: isRed ? primaryColor : Colors.white),
            ),
          )
      ],
    );
  }
}
