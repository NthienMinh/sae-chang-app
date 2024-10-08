import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/result/answer_cubit.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HeaderResult extends StatelessWidget {
  const HeaderResult(
      {super.key,
      required this.id,
      required this.dataId,
      required this.score,
      required this.cubit});

  final int dataId;
  final double score;
  final int id;
  final AnswerCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: cubit,
        builder: (context, i) {
          var text = score > -1
              ? score >= 8
                  ? AppText.txtBestPractice.text
                  : AppText.txtBadPractice.text
              : AppText.txtWaitForMark.text;
          return Column(
            children: [
              SizedBox(
                height: Resizable.padding(context, 20),
              ),
              AutoSizeText(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w800,
                      color: primaryColor)),
              SizedBox(
                height: Resizable.padding(context, 20),
              ),
              score > -1
                  ? CircularPercentIndicator(
                      radius: Resizable.size(context, 65),
                      lineWidth: Resizable.font(context, 12),
                      animation: true,
                      linearGradient: const LinearGradient(
                        begin: Alignment(0, 1),
                        end: Alignment(1, 0),
                        colors: [
                          Color(0xffE33F64),
                          Color(0xffF0B357),
                        ],
                      ),
                      percent: score / 10,
                      animationDuration: 1000,
                      backgroundColor: const Color(0xffC4C4C4),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(score.toStringAsFixed(1),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Resizable.font(context, 25))),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                    )
                  : Image.asset(
                      'assets/icons/ic_clock_wait.png',
                      height: Resizable.font(context, 80),
                    ),
              SizedBox(
                height: Resizable.padding(context, 20),
              ),
            ],
          );
        });
  }
}
