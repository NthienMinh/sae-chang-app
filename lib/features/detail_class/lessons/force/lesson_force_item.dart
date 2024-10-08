import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class LessonForceItem extends StatelessWidget {
  final Function() onTap;
  final Widget widget;
  final String title;
  final String desc;
  final String status;
  final bool isDone;

  const LessonForceItem(
      {required this.onTap,
      required this.widget,
      required this.title,
      required this.desc,
      required this.status,
      required this.isDone,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          bottom: Resizable.padding(context, 10),
          left: Resizable.padding(context, 15),
          right: Resizable.padding(context, 15)),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side:
            BorderSide(color: primaryColor, width: Resizable.size(context, 1)),
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
      ),
      elevation: Resizable.padding(context, 3),
      shadowColor: primaryColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack(
            //   alignment: Alignment.topCenter,
            //   children: [
            //     Container(
            //       color: Colors.transparent,
            //       margin: EdgeInsets.only(
            //           bottom: Resizable.padding(context, 0),
            //           top: Resizable.padding(context, 10)),
            //       child: SimpleShadow(
            //           color:Colors.grey.shade500.withOpacity(0.8),
            //           offset: const Offset(1, 1),
            //           child: widget),
            //     )
            //   ],
            // ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(
                Resizable.padding(context, 10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                      margin: EdgeInsets.zero,
                      elevation: Resizable.padding(context, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      color: isDone
                          ? const Color(0xff33691E).withOpacity(0.8)
                          : Colors.grey.shade600.withOpacity(0.8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 6),
                          vertical: Resizable.padding(context, 2),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: Resizable.font(context, 10),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Resizable.padding(context, 6)),
                    child: Text(title.toUpperCase(),
                        style: TextStyle(
                            height: 1,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                            shadows: [
                              BoxShadow(
                                  color: primaryColor.shade500.withOpacity(0.6),
                                  blurRadius: Resizable.padding(context, 3),
                                  offset: const Offset(1, 1))
                            ])),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Resizable.padding(context, 6),
                    ),
                    child: Text(
                      '$desc\n',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.25,
                        fontSize: Resizable.font(context, 12),
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        // isOpenLesson ? primaryColor : darkPrimaryColor
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}