import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/untils/split_text.dart';
import 'package:sae_chang/widgets/split_text_span.dart';


class SplitTextCustom extends StatelessWidget {
  const SplitTextCustom({
    super.key,
    required this.text,
    this.kanjiSize = 22,
    this.kanjiColor = Colors.black,
    this.kanjiFW = FontWeight.w500,
    this.phoneticFW = FontWeight.w500,
    this.phoneticSize = 10,
    this.vieSize = 14,
    this.phoneticColor = Colors.black,
    this.vieColor = const Color(0xff757575),
    this.isParagraph = false,
    this.vText = '',
    this.isTitle = false,
    this.maxLines,
    this.onShowWord,
    this.foreground,
    this.isReading = false,
    this.isUsingResize = true,
    this.isSelected = false,
  });

  final String text;
  final String vText;
  final double kanjiSize;
  final Color kanjiColor;
  final FontWeight kanjiFW;
  final Color phoneticColor;
  final double phoneticSize;
  final FontWeight phoneticFW;
  final double vieSize;
  final Color vieColor;
  final bool isParagraph;
  final bool isTitle;
  final int? maxLines;
  final bool isReading;
  final Function? onShowWord;
  final Paint? foreground;
  final bool isUsingResize;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    var listString = <String>[];
    if (!isReading) {
      listString = SplitText().splitGrammarString(text);
    } else {
      var spl1 = SplitText().extractSentencesReading(text);
      for (var item in spl1) {
        if (!(item.contains('[') &&
            item.contains(']') &&
            item.contains('||'))) {
          listString.addAll(SplitText().splitGrammarString(item));
        } else {
          listString.add(item);
        }
      }
    }
    var listSpans = <TextSpan>[];
    for (var e in listString) {
      var item = e;
      var type = checkType(item);
      if ([0, 1, 2, 3].contains(type)) {
        createTextSpan(context, type, item, listSpans);
      } else if (type == 4) {
        var text = item.replaceAll('[', '').replaceAll(']', '');

        var spl = text.split('||');
        var id = spl[1];
        var listSpl = SplitText().splitGrammarString(spl[0]);
        for (var i in listSpl) {
          var newType = checkType(i);
          createTextSpan(context, newType, i, listSpans, int.parse(id));
        }
      }
    }
    return IgnorePointer(
      ignoring: !isReading,
      child: Column(
        crossAxisAlignment: isParagraph ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (text.isNotEmpty)
            Container(
              transform: Matrix4.translationValues(0, 3, 0),
              child: RichText(
                maxLines: maxLines,
                textAlign: isParagraph ? TextAlign.start : TextAlign.center,
                text: TextSpan(
                  children: listSpans,
                ),
              ),
            ),
          SizedBox(height: Resizable.padding(context, 2),),
          if (vText.isNotEmpty)
            Builder(builder: (context) {
              List<TextSpan> spans = [];
              List<String> parts = vText.split(RegExp(r'<|>'));
              for (int i = 0; i < parts.length; i++) {
                if (i % 2 == 0) {
                  spans.add(TextSpan(
                      text: parts[i],
                      style: TextStyle(
                        color: vieColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                      )));
                } else {
                  spans.add(TextSpan(
                      text: parts[i],
                      style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                          color: primaryColor)));
                }
              }

              RichText richText = RichText(
                textAlign: isParagraph ? TextAlign.start : TextAlign.center,
                text: TextSpan(
                    children: spans,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: !isUsingResize
                            ? vieSize
                            : Resizable.font(context, vieSize))),
              );
              return richText;
            }),

        ],
      ),
    );
  }

  void addSpanType2or3(
      BuildContext context, int type, String item, List<TextSpan> listSpans,
      [int id = -1]) {
    int start = item.indexOf('{');
    int end = item.indexOf('}');
    if (start != -1 && end != -1) {
      String contents = item.substring(start + 1, end);
      if (contents.contains('|')) {
        List<String> parts = contents.split('|');
        if (parts.length == 2) {
          var kanjiStyle = TextStyle(
              fontWeight: isTitle || type == 3 ? FontWeight.w700 : kanjiFW,
              fontSize: !isUsingResize
                  ? kanjiSize
                  : Resizable.font(context, kanjiSize),
              foreground: foreground,
              color: foreground != null
                  ? null
                  : isTitle || type == 3
                      ? isSelected
                          ? Colors.black
                          : primaryColor
                      : kanjiColor,
              fontFamily: 'GenShinGothic');
          var phoneticStyle = TextStyle(
              fontFamily: 'GenShinGothic',
              fontSize: !isUsingResize
                  ? phoneticSize
                  : Resizable.font(context, phoneticSize),
              fontWeight: phoneticFW,
              foreground: foreground,
              color: foreground != null ? null : phoneticColor);

          listSpans.add(SplitTextSpan.japanType2or3(
              phonetic: parts[1],
              kanji: parts[0],
              kanjiStyle: kanjiStyle,
              phoneticStyle: phoneticStyle,
              onClick: id == -1
                  ? null
                  : () {
                      onShowWord!(id);
                    }));
        }
      } else {
        var style = TextStyle(
            fontWeight:
                isTitle || type == 3 ? FontWeight.w700 : FontWeight.w500,
            fontSize:
                !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
            foreground: foreground,
            color: foreground != null
                ? null
                : isTitle || type == 3
                    ? primaryColor
                    : kanjiColor,
            fontFamily: 'GenShinGothic');

        listSpans.add(SplitTextSpan.japanType1orDefault(
            style: style,
            text: contents,
            onClick: id == -1
                ? null
                : () {
                    onShowWord!(id);
                  }));
      }
    }
  }

  void addSpanType0(
      BuildContext context, int type, String item, List<TextSpan> listSpans) {
    if (CustomCheck.isVietnameseCharacter(item)) {
      var style = TextStyle(
        fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
        fontSize:
            !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
        foreground: foreground,
        color: foreground != null
            ? null
            : isTitle
                ? primaryColor
                : kanjiColor,
      );
      listSpans
          .add(SplitTextSpan.japanType1orDefault(style: style, text: item));
    } else {
      var listS = <TextSpan>[];
      List<String> words = item.split('');
      for (var k in words) {
        var style = TextStyle(
            fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
            fontSize:
                !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
            color: foreground != null
                ? null
                : isTitle
                    ? primaryColor
                    : kanjiColor,
            foreground: foreground,
            fontFamily:
                CustomCheck.isVietnameseCharacter(k) ? null : 'GenShinGothic');
        listS.add(SplitTextSpan.japanType1orDefault(style: style, text: k));
      }
      listSpans.addAll(listS);
    }
  }

  void addSpanType1(
      BuildContext context, int type, String item, List<TextSpan> listSpans,
      [int id = -1]) {
    final RegExp pattern = RegExp(r'<(.*?)>');
    final match = pattern.firstMatch(item);
    if (match != null) {
      var type1 = match.group(1)!;
      if (CustomCheck.isVietnameseCharacter(type1)) {
        var style = TextStyle(
          fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
          fontSize:
              !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
          color: foreground != null
              ? null
              : isSelected
                  ? Colors.black
                  : primaryColor,
          foreground: foreground,
        );
        listSpans.add(SplitTextSpan.japanType1orDefault(
            style: style,
            text: type1,
            onClick: id == -1
                ? null
                : () {
                    onShowWord!(id);
                  }));
      } else {
        var listS = <TextSpan>[];
        List<String> words = type1.split('');
        for (var k in words) {
          var style = TextStyle(
              fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
              fontSize: !isUsingResize
                  ? kanjiSize
                  : Resizable.font(context, kanjiSize),
              color: foreground != null
                  ? null
                  : isSelected
                      ? Colors.black
                      : primaryColor,
              foreground: foreground,
              fontFamily: CustomCheck.isVietnameseCharacter(k)
                  ? null
                  : 'GenShinGothic');
          listS.add(SplitTextSpan.japanType1orDefault(
              style: style,
              text: k,
              onClick: id == -1
                  ? null
                  : () {
                      onShowWord!(id);
                    }));
        }
        listSpans.addAll(listS);
      }
    }
  }

  void createTextSpan(
      BuildContext context, int type, String item, List<TextSpan> listSpans,
      [int id = -1]) {
    if (type == 0) {
      addSpanType0(context, type, item, listSpans);
    } else if (type == 1) {
      addSpanType1(context, type, item, listSpans, id);
    } else if (type == 2 || type == 3) {
      addSpanType2or3(context, type, item, listSpans, id);
    }
  }
}

int checkType(String s) {
  if (isStringValidType4(s)) return 4;
  if (isStringValidType3(s)) return 3;
  if (isStringValidType2(s)) return 2;
  if (isStringValidType1(s)) return 1;
  return 0;
}

bool isStringValidType1(String input) {
  final RegExp pattern = RegExp(r'^<[^<>]+>$');
  return pattern.hasMatch(input);
}

bool isStringValidType2(String input) {
  final RegExp pattern = RegExp(r'^\{[^{}]+\}$');
  return pattern.hasMatch(input);
}

bool isStringValidType3(String input) {
  final RegExp pattern = RegExp(r'^<\{[^{}]+\}>$');
  return pattern.hasMatch(input);
}

bool isStringValidType4(String input) {
  return input.contains('[') && input.contains(']') && input.contains('||');
}

// bool isStringValidType4(String input) {
//   final RegExp pattern = RegExp(r'<\{[^{}]+\}[^{}]+>');
//   return pattern.hasMatch(input);
// }