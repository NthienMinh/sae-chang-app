import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';


class ResultWordMatched extends StatelessWidget {
  const ResultWordMatched({super.key, required this.splitMap,
    this.background = primaryColor,
    this.textColor = Colors.white,
    this.showIcon = true});
  final List<String> splitMap;
  final bool showIcon;
  final Color background;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: Resizable.padding(context, 5)),
            margin: EdgeInsets.symmetric(
                horizontal:
                Resizable.padding(context, showIcon? 40 : 20),
                vertical:
                Resizable.padding(context, 10)),
            child: Container(
              constraints: BoxConstraints(
                  minHeight:
                  Resizable.size(context, 45)),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(
                    Resizable.size(context, 7)),
                border: Border.all(
                    width: 1, color: background),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(
                              Resizable.padding(
                                  context, 10)),
                          child: Center(
                              child: SplitTextCustom(
                                  text: splitMap[0].trim(),
                                  isSelected: true,
                                  phoneticSize: 10,
                                  kanjiFW: FontWeight.w600,
                                  kanjiColor: textColor,
                                  phoneticColor:  textColor,
                                  kanjiSize: 16)
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                              padding:
                              EdgeInsets.all(
                                  Resizable.padding(context, 10)),
                              child:SplitTextCustom(
                                  text: splitMap[1].trim(),
                                  phoneticSize: 10,
                                  isSelected: true,
                                  kanjiFW: FontWeight.w600,
                                  kanjiColor: textColor,
                                  phoneticColor:  textColor,
                                  kanjiSize: 16)
                          ),
                        ),
                      )
                    ],
                  ),
                  const Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: VerticalDivider(
                          color: Colors.white,
                          width: 1,
                          thickness: 2,
                          endIndent: 5,
                          indent: 5,
                        ),
                      ))
                ],
              ),
            )),
        if(showIcon)
        Positioned.fill(
          top: Resizable.padding(context, 6),
          right: Resizable.padding(context, 32),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
                height: Resizable.size(context, 20),
                width: Resizable.size(context, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      Resizable.size(context, 50)),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: Resizable.size(context, 20),
                  color: primaryColor,
                )),
          ),
        ),
      ],
    );
  }
}
