import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/skill/lesson_skill_view.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/models/base_model/student_lesson_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';

import 'force/lesson_force_view.dart';

class LessonClassView extends StatelessWidget {
  final LessonModel lesson;
  final dynamic hw;
  final String teacherNote;
  final Function() reload;
  final UserClassModel userClass;
  final ClassModel classModel;
  final StudentLessonModel? lessonState;

  const LessonClassView(
      {super.key,
      required this.lesson,
      required this.hw,
      required this.teacherNote,
      required this.reload,
      required this.userClass,
      required this.classModel,
      required this.lessonState});

  bool get isSubClass => classModel.isSubClass;

  bool checkEmpty() {
    return lesson.skills.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarTemplateTwoTitle(
          'MÃ LỚP: ${isSubClass ? AppText.txtElective.text : classModel.code}',
          lesson.title.toUpperCase(),
          context,
          actions: const [
            SizedBox(
              width: 60,
            )
          ],
        ),
        body: Container(
          alignment: checkEmpty() ? Alignment.center : Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LessonForceView(
                  lesson: lesson,
                  classModel: classModel,
                  teacherNote: teacherNote,
                  reload: reload,
                  userId: userClass.userId,
                  resultId:
                      lessonState == null ? 0 : lessonState!.lessonResultId,
                  status:  lessonState == null ? null : double.parse(lessonState!.skills['hw'].toString()),
                ),
                LessonSkillView(
                  lesson,
                  classModel.classId,
                  teacherNote,
                  reload: reload,
                ),
                if (checkEmpty())
                  Center(
                    child: Text(
                      AppText.txtLessonEmpty.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}
