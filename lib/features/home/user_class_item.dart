import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/shadow_text.dart';
import 'package:sae_chang/widgets/slide_progress.dart';

class UserClassItem extends StatelessWidget {
  const UserClassItem(
      {super.key,
      required this.isCompleted,
      required this.index,
      required this.onPressed,
      required this.description,
      required this.classCode,
      required this.title,
      required this.isPrimary,
      required this.progress,
      required this.text});
  final bool isCompleted;
  final Function() onPressed;
  final String description;
  final String classCode;
  final String title;
  final bool isPrimary;
  final double progress;
  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          bottom: Resizable.padding(context, 7),
          left: Resizable.padding(context, 10),
          right: Resizable.padding(context, 10)),
      color: isCompleted
          ? Colors.white
          : (isPrimary ? Colors.white : primaryColor),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: isCompleted ? greyColor.shade600 : primaryColor,
            width: Resizable.size(context, 1.5)),
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
      ),
      elevation: Resizable.padding(context, 3),
      shadowColor: isCompleted
          ? Colors.grey.shade500.withOpacity(0.8)
          : primaryColor.withOpacity(0.6),
      child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
          child: Padding(padding: EdgeInsets.all(Resizable.padding(context, 7)),child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.all(Resizable.padding(context,  5)),
                      child: Image.asset(
                     'assets/icons/ic_learn_1.png',
                    fit: BoxFit.cover,
                  ))),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: Resizable.padding(context, 10),
                        left: Resizable.padding(context, 5)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classCode.toUpperCase(),
                          style: TextStyle(
                              color: isPrimary
                                  ? Colors.grey.shade800
                                  : Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.size(context, 11),
                              shadows: [
                                BoxShadow(
                                    color:
                                    Colors.grey.shade500.withOpacity(0.8),
                                    blurRadius: Resizable.padding(context, 3),
                                    offset: const Offset(1, 1)),
                              ]),
                        ),
                        AutoSizeText(
                          overflow: TextOverflow.ellipsis,
                          title,
                          maxLines: 1,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: Resizable.size(context, 18),
                          ),
                        ),
                        isCompleted
                            ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShadowText(
                                "(Đã Kết Thúc)",
                                shadowColor: primaryColor,
                                shadow: Resizable.padding(context, 3),
                                color: primaryColor,
                                style: TextStyle(
                                  fontSize: Resizable.font(context, 13),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ])
                            : Container(
                            constraints: BoxConstraints(
                              maxWidth: Resizable.padding(context, 290),
                            ),
                            child: SlideProgress(
                              isRed: isPrimary,
                              percent: progress,
                              text: text,
                            )),
                        description.isNotEmpty
                            ? Text(
                          overflow: TextOverflow.ellipsis,
                          description,
                          maxLines: 5,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              height: 1.25,
                              fontSize: Resizable.font(context, 12),
                              fontWeight: FontWeight.w500,
                              color: isPrimary
                                  ? Colors.grey.shade600
                                  : Colors.white),
                        )
                            : Container(),
                      ],
                    ),
                  ))
            ],
          ))),
    );
  }
}
