import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class IconResult extends StatelessWidget {
  const IconResult({super.key, required this.answerModel, required this.index});
  final AnswerModel answerModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/${answerModel.score == -1 ? 'ic_clock_wait.png' : answerModel.score > -1 && answerModel.score < 5 ? 'ic_bt_wrong.png' : 'ic_checked.png'}',
            height: 25,
          ),
          const SizedBox(
            width: 6,
          ),
          IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  "CÂU ${index + 1}",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Resizable.font(context, 17)),
                ),
                const Divider(
                  color: primaryColor,
                  height: 2,
                  thickness: 2,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
