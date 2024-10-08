import 'package:flutter/material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';


class QuestionCustom extends StatelessWidget {
  const QuestionCustom({super.key, required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    // var isBig =  question.length < 12;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 30),
          vertical: Resizable.padding(context, 5)),
      child: SplitTextCustom(
          text: question,
          phoneticSize: Resizable.font(context, 15),
          kanjiFW: FontWeight.w700,
          kanjiSize: Resizable.font(context, 23)),
    );
  }
}
