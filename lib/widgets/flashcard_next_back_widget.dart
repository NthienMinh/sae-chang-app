import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class FlashcardNextBackWidget extends StatelessWidget {
  final Function(BuildContext) next;
  final Function(BuildContext) prev;
  final String text;

  const FlashcardNextBackWidget(this.next, this.prev, {super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: Resizable.size(context, 80) * 2 +
      Resizable.size(context, 1) +
      ((text).isNotEmpty
          ? Resizable.size(context, 50) + Resizable.size(context, 1)
          : 0),
          height: Resizable.size(context, 40),
          child: Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: primaryColor.withOpacity(.5), width: 1),
      borderRadius: BorderRadius.circular(Resizable.size(context, 30)),
    ),
    // shadowColor: PrimaryColor.value,
    elevation: Resizable.size(context, 5),
    shadowColor: primaryColor,
    color: primaryColor,
    child: Row(
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
          onTap: () {
            prev(context);
          },
          child: Container(
            alignment: Alignment.center,
            width: Resizable.size(context, 80),
            child: Icon(
              Icons.arrow_left,
              color: Colors.white,
              size: Resizable.size(context, 35),
            ),
          ),
        ),
        Container(
          // color: PrimaryColor.value.shade900,
          color: Colors.white,
          height: Resizable.size(context, 15),
          margin: EdgeInsets.symmetric(
            vertical: Resizable.padding(context, 12),
          ),
          width: Resizable.size(context, 1),
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
                  fontSize: Resizable.font(context, 12),
                  color: Colors.white),
            ),
          ),
        if ((text).isNotEmpty)
          Container(
            // color: PrimaryColor.value.shade900,
            color: Colors.white,
            height: Resizable.size(context, 15),
            margin: EdgeInsets.symmetric(
              vertical: Resizable.padding(context, 12),
            ),
            width: Resizable.size(context, 1),
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
          onTap: () {
            next(context);
          },
          child: Container(
            alignment: Alignment.center,
            width: Resizable.size(context, 80),
            child: Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: Resizable.size(context, 35),
            ),
          ),
        ),

      ],
    ),
          ),
        );
  }
}
