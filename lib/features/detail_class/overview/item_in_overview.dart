import 'package:flutter/Material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../../configs/color_configs.dart';

class ItemInOverView extends StatelessWidget {
  const ItemInOverView(
      {super.key,
      required this.title,
      required this.icon,
      required this.progress,
      required this.isScore});

  final String title;
  final String icon;
  final double progress;
  final bool isScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      shadowColor: Colors.grey.shade500.withOpacity(0.8),
      elevation: Resizable.padding(context, 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
      ),
      child: Container(
        padding: EdgeInsets.only(
            right: Resizable.padding(context, 20)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
            border: Border.all(color: primaryColor, width: 1.5)),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Padding(padding: EdgeInsets.all(Resizable.padding(context, 10)),child: Image.asset(icon,
                    color: primaryColor))),
            SizedBox(
              width: Resizable.size(context, 10),
            ),
            Expanded(
              flex: 4,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title.trim().toUpperCase(),
                          style: TextStyle(
                            height: 1.25,
                            fontSize: Resizable.font(context, 14),
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.8),
                          )),
                      Text(
                        isScore
                            ? progress.toStringAsFixed(1)
                            : '${(progress * 100).toInt()}%',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          height: 1,
                          color: Colors.black.withOpacity(0.8),
                          fontSize: Resizable.font(context, 12),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ]),
                SizedBox(height: Resizable.padding(context, 5)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                        padding:
                            EdgeInsets.only(top: Resizable.padding(context, 2)),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 6,
                          animationDuration: 2500,
                          percent: isScore ? progress / 10 : progress,
                          padding: EdgeInsets.zero,
                          barRadius: const Radius.circular(8),
                          backgroundColor: greyColor.shade100,
                          progressColor: primaryColor,
                        ),
                      )),
                    ])
              ],
            )),
          ],
        ),
      ),
    );
  }
}
