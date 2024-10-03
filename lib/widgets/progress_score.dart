import 'package:flutter/Material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class ProgressScore extends StatelessWidget {
  const ProgressScore(
      {super.key,
        required this.result,
        required this.size,
        this.isShowText = true,
        this.fontScore,
        this.fontText,
        this.weight = 8, this.elevation = 3});
  final double result;
  final double size;
  final double? fontScore;
  final double? fontText;
  final bool isShowText;
  final double weight;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Center(
            child: Container(
              height: Resizable.size(context, size - weight),
              width: Resizable.size(context, size - weight),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow:  elevation == 0 ? null : [
                  BoxShadow(
                    color: const Color(0xffE33F64).withOpacity(0.2),
                    offset: const Offset(0.0, 0.0),
                    spreadRadius: 4,
                    blurRadius: elevation,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: FittedBox(
              child: CircularPercentIndicator(
                radius: Resizable.size(context, size / 2),
                lineWidth: weight,
                animation: true,
                linearGradient: const LinearGradient(
                  begin: Alignment(0, 1),
                  end: Alignment(1, 0),
                  colors: [
                    Color(0xffE33F64),
                    Color(0xffF0B357),
                  ],
                ),
                percent: result / 10,
                animationDuration: 1000,
                backgroundColor: const Color(0xffe6e6e6),
                center: !isShowText
                    ? null
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(result.toStringAsFixed(1),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: fontScore??Resizable.font(context, size / 4))),
                    Text(AppText.txtScore.text.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:
                            fontText??Resizable.font(context, size / 10))),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ),
        )
      ],
    );
  }
}