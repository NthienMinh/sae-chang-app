import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/student_lesson_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/shadow_text.dart';

class ItemLesson extends StatelessWidget {
  final int index, classId;
  final LessonModel lesson;
  final String status, level;
  final StudentLessonModel? lessonState;
  final bool isLoading;
  final Function() reload;
  final UserClassModel userClass;
  final ClassModel classModel;

  const ItemLesson(this.index, this.status, this.lessonState, this.isLoading,
      {super.key,
      required this.lesson,
      required this.classId,
      required this.reload,
      required this.level,required this.userClass, required this.classModel});

  bool get isOpenLesson => (status != "Pending");

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          bottom: Resizable.padding(context, 7),
          left: Resizable.padding(context, 20),
          right: Resizable.padding(context, 20)),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: !isOpenLesson ? greyColor.shade600 : primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
      ),
      elevation: Resizable.padding(context, 3),
      shadowColor: !isOpenLesson
          ? Colors.grey.shade500.withOpacity(0.8)
          : primaryColor.shade500.withOpacity(0.6),
      child: InkWell(
          onTap: () async {
            await onTap(isOpenLesson, context);
          },
          borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                flex: 2,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset('assets/images/img_border_2.png',scale: 0.7,),
                    Column(
                      children: [
                        Text("BÀI",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: Resizable.font(context, 20))),
                        Text(level.toUpperCase(),
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: Resizable.font(context, 20)))
                      ],
                    )
                  ],
                )),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    left: Resizable.padding(context, 3),
                    right: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (lessonState != null)
                            Card(
                                margin: EdgeInsets.zero,
                                elevation: Resizable.padding(context, 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                color: (lessonState!.timeKeeping == 0)
                                    ? Colors.grey.shade800
                                    : lessonState!.timeKeeping == 1
                                    ? const Color(0xff33691E)
                                    : const Color(0xffE65100),
                                // .withOpacity(0.8),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                    Resizable.padding(context, 6),
                                    vertical: Resizable.padding(context, 2),
                                  ),
                                  child: Text(
                                    getStatusStudy,
                                    style: TextStyle(
                                      fontSize: Resizable.font(context, 10),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          if (lessonState != null &&
                              lessonState!.skills['hw'] < -1 &&
                              lessonState!.timeKeeping > 0 &&
                              lessonState!.timeKeeping < 5)
                            Row(
                              children: [
                                Container(
                                  height: Resizable.size(context, 12),
                                  width: Resizable.size(context, 1),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                      Resizable.padding(context, 2)),
                                  // color: primaryColor,
                                ),
                                Card(
                                    margin: EdgeInsets.zero,
                                    elevation:
                                    Resizable.padding(context, 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(1000),
                                    ),
                                    color: const Color(0xFFE43838),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                        Resizable.padding(context, 6),
                                        vertical:
                                        Resizable.padding(context, 2),
                                      ),
                                      child: Text(
                                        AppText.txtNotDoHomework.text,
                                        style: TextStyle(
                                          fontSize:
                                          Resizable.font(context, 10),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: Resizable.padding(context, 7)),
                          child: Text(lesson.title,
                              style: TextStyle(
                                  height: 1.25,
                                  fontSize: Resizable.font(context, 18),
                                  fontWeight: FontWeight.w800,
                                  color: !isOpenLesson
                                      ? greyColor.shade600
                                      : primaryColor,
                                  shadows: [
                                    BoxShadow(
                                        color: !isOpenLesson
                                            ? Colors.grey.shade500
                                            .withOpacity(0.9)
                                            : primaryColor.shade500
                                            .withOpacity(0.6),
                                        blurRadius:
                                        Resizable.padding(context, 3),
                                        offset: const Offset(1, 1))
                                  ]
                              ))),
                      if (!isOpenLesson)
                        ShadowText(
                          "(Buổi Học Chưa Bắt Đầu)",
                          shadowColor: primaryColor,
                          shadow: Resizable.padding(context, 3),
                          color: primaryColor,
                          style: TextStyle(
                            fontSize: Resizable.font(context, 13),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      // if (isOpenLesson && isShowProgress)
                      //   NewClassLessonProgress(
                      //       lesson: lesson,
                      //       lessonState: lessonState,
                      //       isOpenLesson: isOpenLesson),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Resizable.padding(context, 5),
                        ),
                        child: AutoSizeText(
                          lesson.description,
                          maxLines: 5,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 1,
                          style: TextStyle(
                              height: 1.25,
                              fontSize: Resizable.font(context, 13),
                              fontWeight: FontWeight.w500,
                              color: isOpenLesson
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade700),
                        ),
                      )
                    ],
                  ),
                ))
          ])),
    );
  }

  onTap(bool isOpenLesson, BuildContext context) async {
    if (isOpenLesson) {
      if (lesson.isCustom ) {
        // if (context.mounted) {
        //   Navigator.pushNamed(context, Routes.customLesson, arguments: {
        //     'lesson': lesson,
        //     'classId': int.parse(classId),
        //     'status': lessonState?.hw,
        //     'teacherNote': teacherNote,
        //     'isPreStudy': isPreStudy,
        //     'reload': reload,
        //     'isLogin': isLogin,
        //     'userClass': userClass
        //   });
        // }
      } else {
        if (context.mounted) {
          debugPrint('=>>>>>>>>>>>>>> ${lesson.lessonId}');
          Navigator.pushNamed(context, Routes.lesson, arguments: {
            'lesson': lesson,
            'hw': lessonState == null ? null :lessonState!.skills['hw'],
            'teacherNote': lessonState == null ? "" : lessonState!.teacherNoteForStudent,
            'reload': reload,
            'userClass': userClass,
            'studentLesson': lessonState,
            'class': classModel,
          });
        }
      }
    }
  }

  String get getStatusStudy {
    if (isLoading || !isOpenLesson) {
      return AppText.txtLessonNotStart.text;
    } else if (lessonState == null || lessonState!.timeKeeping == 0) {
      return AppText.txtNotCheck.text;
    } else if (lessonState!.timeKeeping == 1) {
      return AppText.txtJoin.text;
    } else if (lessonState!.timeKeeping == 2) {
      return AppText.txtLate.text;
    } else if (lessonState!.timeKeeping == 3) {
      return AppText.txtOutSoon.text;
    } else if (lessonState!.timeKeeping == 4) {
      return AppText.txtLateAndOutSoon.text;
    } else if (lessonState!.timeKeeping == 5) {
      return AppText.txtPermission.text;
    } else if (lessonState!.timeKeeping == 6) {
      return AppText.txtUnauthorized.text;
    } else {
      return "Error";
    }
  }
}
