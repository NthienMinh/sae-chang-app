import 'package:flutter/Material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'class_overview_cubit.dart';

class ProgressCircleOverView extends StatelessWidget {
  const ProgressCircleOverView({super.key,required this.cubit});
  final ClassOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    double progress = cubit.numAllLesson == 0 ? 0 : (cubit.numLessonOpened / cubit.numAllLesson).toDouble();
    return Column(
      children: [
        SizedBox(
          height: Resizable.size(context, 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: Resizable.size(context, 120),
                  width: Resizable.size(context, 120),
                  child: Center(
                    child: Center(
                      child: Container(
                        height: Resizable.size(context, 120),
                        width: Resizable.size(context, 120),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500.withOpacity(0.6),
                              offset: const Offset(1, 1),
                              spreadRadius: 3,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${cubit.numLessonOpened}/${cubit.numAllLesson}',
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 24),
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'BUỔI',
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 12),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: FittedBox(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularPercentIndicator(
                        lineWidth: Resizable.size(context, 12),
                        animationDuration: 2000,
                        percent: progress,
                        animation: true,
                        linearGradient: const LinearGradient(
                          colors: primaryGradientColor,
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        backgroundColor: Colors.transparent,
                        circularStrokeCap: CircularStrokeCap.round,
                        radius: 75,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}