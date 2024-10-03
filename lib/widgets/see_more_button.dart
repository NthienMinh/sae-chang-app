import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/shadow_text.dart';

class SeeMoreButton extends StatelessWidget {
  final Function() onTap;
  final bool isShortCut;
  final int sum;
  final int lengthShow;
  const SeeMoreButton(this.isShortCut, this.sum,
      {required this.onTap, this.lengthShow = 2, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 3),
          horizontal: Resizable.padding(context, 10)),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Card(
              elevation: Resizable.size(context, 10),
              shadowColor: primaryColor,
              //color: const Color(0xFFFCEAEE),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: primaryColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.zero,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 20),
                      vertical: Resizable.padding(context, 2)),
                  child: ShadowText(
                      isShortCut
                          ? 'Thu Gọn'.toUpperCase()
                          : 'Xem Thêm (${sum - lengthShow})'.toUpperCase(),
                      color: primaryColor,
                      shadowColor: primaryColor,
                      shadow: Resizable.padding(context, 3),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: Resizable.font(context, 12),
                          fontWeight: FontWeight.w800)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
