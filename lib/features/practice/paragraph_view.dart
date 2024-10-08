import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

import 'multiple_choice/paragraph_dialog.dart';

class ParagraphView extends StatelessWidget {
  const ParagraphView({super.key, required this.questionModel, this.isResult = false});

  final QuestionModel questionModel;
  final bool isResult;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: isResult ? EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 0),
            vertical: Resizable.padding(context, 10)).copyWith(
          right: Resizable.padding(context, 60)
        ) : EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 30),
            vertical: Resizable.padding(context, 10)),
        child: Container(

          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 20)),
              border: Border.all(width: 1, color: primaryColor),
              color: Colors.white),
          padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 10),
            vertical: Resizable.padding(context, 10),
          ),
          child: LayoutBuilder(builder: (context, c) {
            var style = TextStyle(
                fontSize: Resizable.font(context, 15),
                fontWeight: FontWeight.w500);
            final span = TextSpan(text: questionModel.paragraph, style: style);
            final tp =
                TextPainter(text: span, textDirection: TextDirection.ltr);
            tp.layout(maxWidth: c.maxWidth);
            final numLines = tp.computeLineMetrics().length;
            bool isShowMore = numLines >= 4;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SplitTextCustom(
                    text: questionModel.paragraph.trim().replaceAll('\n',''),
                    isParagraph: true,
                    phoneticSize: 8,
                    kanjiSize: 15,
                    kanjiFW: FontWeight.w500,
                    maxLines: 4,

                  ),
                ),
                if (isShowMore)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            context = context;
                            return LongTextDialogView(
                              text: questionModel.paragraph,
                            );
                          });
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(AppText.txtSeeMore.text,
                          style: TextStyle(
                              color: primaryColor.shade300,
                              fontSize: Resizable.font(context, 12),
                              fontWeight: FontWeight.w500)),
                    ),
                  )
              ],
            );
          }),
        ));
  }
}
