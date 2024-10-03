import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ChooseLevelButton extends StatelessWidget {
  const ChooseLevelButton({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 3,
          color: primaryColor,
          shadowColor: Colors.grey.shade500.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Container(
            constraints: BoxConstraints(minWidth: Resizable.size(context, 120)),
            padding: EdgeInsets.only(
              left: Resizable.padding(context, 2),
              right: Resizable.padding(context, 10),
              top: Resizable.padding(context, 2),
              bottom: Resizable.padding(context, 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SimpleShadow(
                        child: Image.asset(
                      'assets/icons/ic_home_logo.png',
                      width: Resizable.size(context, 30),
                      height: Resizable.size(context, 30),
                    )),
                    SizedBox(width: Resizable.padding(context, 7)),
                    Text(
                        title == AppText.txtHanNguSaeChang.text
                            ? "SAE-CHANG"
                            : title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 16),
                            fontWeight: FontWeight.w800)),
                  ],
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: Resizable.padding(context, 5)),
                    child: Image.asset('assets/icons/ic_home_dropdown.png',
                        color: Colors.white,
                        width: Resizable.size(context, 12),
                        height: Resizable.size(context, 12)))
              ],
            ),
          ),
        ),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(1000),
            onTap: () => Navigator.pushNamed(context, Routes.chooseLevel),
          ),
        ))
      ],
    );
  }
}
