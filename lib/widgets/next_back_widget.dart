import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class NextBackWidget extends StatelessWidget {
  final Function() next;
  final Function() prev;
  final String text;

  const NextBackWidget(this.next, this.prev, {super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  Resizable.size(context, 30),
                ),
                bottomLeft: Radius.circular(
                  Resizable.size(context, 30),
                ),
              ),
              highlightColor: primaryColor.shade500.withAlpha(120),
              onTap: prev,
              child: Icon(
                Icons.arrow_left,
                color: primaryColor,
                size: Resizable.size(context, 35),
              )
            ),
            if ((text).isNotEmpty)
              Container(
                alignment: Alignment.center,
                width: Resizable.size(context, 50),
                child: AutoSizeText(
                  text,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Resizable.font(context, 15),
                      color: Colors.black),
                ),
              ),
            InkWell(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  Resizable.size(context, 30),
                ),
                bottomRight: Radius.circular(
                  Resizable.size(context, 30),
                ),
              ),
              highlightColor: primaryColor.shade500.withAlpha(120),
              onTap: next,
              child: Icon(
                Icons.arrow_right,
                color: primaryColor,
                size: Resizable.size(context, 35),
              ),
            )
          ],
        ));
  }
}