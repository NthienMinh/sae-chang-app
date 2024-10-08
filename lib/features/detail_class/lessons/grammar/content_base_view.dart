import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

abstract class GrammarContentBaseView extends StatelessWidget {
  const GrammarContentBaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: Resizable.padding(context, 10),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: Resizable.padding(context, 10.0),
                  ),
                  child: Image.asset(
                    icon,
                    width: Resizable.size(context, 25.0),
                    height: Resizable.size(context, 25.0),
                    color: primaryColor,
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          // fontFamily: Languages.customFont,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                          fontSize: Resizable.font(context, 18,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        html(context),
      ],
    );
  }

  Widget html(BuildContext context);

  String get icon;

  String get title;
}