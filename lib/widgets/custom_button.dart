import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color backgroundColor;
  final Color textColor;
  final double height, fontSize;
  final FontWeight fontWeight;
  final bool border;
  final double paddingTop;
  final double paddingContent;
  final double elevation;
  final bool enable;

  const CustomButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.backgroundColor,
      required this.textColor,
      this.height = 60,
      this.enable = true,
      this.fontSize = 16,
      this.paddingTop = 10,
      this.paddingContent = 15,
      this.fontWeight = FontWeight.w800,
      this.elevation = 3,
      this.border = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Resizable.padding(context, height),
      margin: EdgeInsets.only(top: Resizable.padding(context, paddingTop)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Resizable.size(context, 90)),
          border: Border.all(
              width: 1,
              color: border ? primaryColor.shade500 : Colors.transparent)),
      child: ElevatedButton(
        onPressed: !enable
            ? null
            : () {
                onTap();
              },
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return backgroundColor.withOpacity(0.8);
              }
              return backgroundColor;
            }),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(
              horizontal: paddingContent,
            )),
            elevation: WidgetStateProperty.all(elevation),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000)))),
        child: AutoSizeText(title,
            maxLines: 1,
            style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: Resizable.size(context, fontSize))),
      ),
    );
  }
}
