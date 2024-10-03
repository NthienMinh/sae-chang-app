import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';

class SplitTextSpan {
  static TextSpan japanType1orDefault({
    required TextStyle style,
    required String text,
    Function? onClick,
  }) {
    return TextSpan(
      text: text,
      style: style.copyWith(

        decoration: onClick == null ? null : TextDecoration.underline,
        decorationStyle:  onClick == null ? null : TextDecorationStyle.dashed,
        decorationColor: onClick == null ? null : primaryColor,
        decorationThickness: onClick == null ? null : 1.5,
      ),

      recognizer:  TapGestureRecognizer()
        ..onTap = () {

          if(onClick == null) return;
          onClick();// Call the function when tapped
        },
    );
  }


  static TextSpan japanType2or3({
    required TextStyle kanjiStyle,
    required TextStyle phoneticStyle,
    required String kanji,
    required String phonetic,
    Function? onClick,

  }) {
    return  TextSpan(
      style: kanjiStyle.copyWith(
        decoration: onClick == null ? null : TextDecoration.underline,
        decorationStyle:  onClick == null ? null : TextDecorationStyle.dashed,
        decorationColor: onClick == null ? null : primaryColor,
          decorationThickness: onClick == null ? null : 1.5,
      ),
        text: '\u200C',

        children: <InlineSpan>[
      WidgetSpan(
        baseline: TextBaseline.alphabetic,
        alignment: PlaceholderAlignment.bottom,

        child: GestureDetector(
          onTap: onClick ==null ? null : (){
            onClick();

          },
          child: Container(
            transform: Matrix4.translationValues(0, -3.25, 0),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(phonetic, style: phoneticStyle),
                Text(kanji,
                    style: kanjiStyle.copyWith(
                  height: 1.1,
                      fontWeight: FontWeight.w700
                )),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

}
