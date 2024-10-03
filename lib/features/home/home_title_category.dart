import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/shadow_text.dart';
import 'package:simple_shadow/simple_shadow.dart';

class HomeTitleCategory extends StatelessWidget {
  final String title;
  final String icon;

  const HomeTitleCategory(this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: Resizable.padding(context, 14),
            top: Resizable.padding(context, 20)),
        child: Row(
          children: [
            Card(
              margin: EdgeInsets.zero,
              color: primaryColor,
              shape: const CircleBorder(),
              elevation: 3,
              shadowColor: primaryColor.withOpacity(0.8),
              child: Container(
                width: Resizable.size(context, 38),
                height: Resizable.size(context, 38),
                alignment: Alignment.center,
                child: SimpleShadow(
                    child: Image.asset(
                  icon,
                  color: Colors.white,
                  width: Resizable.size(context, 22),
                  height: Resizable.size(context, 22),
                )),
              ),
            ),
            SizedBox(width: Resizable.size(context, 8)),
            ShadowText(
              shadow: 1,
              shadowColor: primaryColor.withOpacity(0.6),
              title.toUpperCase(),
              style: TextStyle(
                color: primaryColor,
                fontSize: Resizable.font(context, 20),
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        ));
  }
}