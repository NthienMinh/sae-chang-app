import 'package:flutter/material.dart';
import 'package:sae_chang/features/detail_class/lessons/skill/skill_item.dart';
import 'package:sae_chang/features/home/home_skill_type.dart';
import 'package:sae_chang/features/home/home_title_category.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/scroll_horizontal_view.dart';

class LessonSkillView extends StatelessWidget {
  const LessonSkillView(this.lesson, this.classId, this.teacherNote,
      {super.key, required this.reload});

  final LessonModel lesson;
  final int classId;
  final String teacherNote;
  final Function() reload;

  List<HomeSkillType> get listSkill {
    List<HomeSkillType> list = [];
    if (lesson.skills.contains('listening')) {
      list.add(HomeSkillType.listening);
    }
    if (lesson.skills.contains('vocabulary')) {
      list.add(HomeSkillType.vocabulary);
    }
    if (lesson.skills.contains('grammar')) {
      list.add(HomeSkillType.grammar);
    }
    if (lesson.skills.contains('reading')) {
      list.add(HomeSkillType.reading);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return listSkill.isEmpty
        ? Container()
        : SingleChildScrollView(
            child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 20)),
                child: const HomeTitleCategory(
                    "Kỹ năng", 'assets/icons/ic_progress_submit.png'),
              ),
              HomeScrollHorizontalView(
                  height: (MediaQuery.of(context).size.width -
                          2 * Resizable.padding(context, 60) -
                          Resizable.padding(context, 10)) *
                      200 /
                      160 /
                      2,
                  list: [
                    ...listSkill.map((i) => SkillItem(i,
                        onTap: () => onPressed(context, i), isRed: false))
                  ])
            ],
          ));
  }

  onPressed(BuildContext context, HomeSkillType type) async {
    if (type == HomeSkillType.listening) {
      Navigator.pushNamed(context, Routes.practiceListening, arguments: {
        'lessonId': lesson.lessonId,
        'update': null,
        'status': -2,
        'classId': classId
      });
    }
    if (type == HomeSkillType.vocabulary) {
      Navigator.pushNamed(context, Routes.vocabulary, arguments: {
        'lessonId': lesson.lessonId,
        'update': null,
        'status': -2,
        'classId': classId });
    }
    if (type == HomeSkillType.grammar) {
      Navigator.pushNamed(context, Routes.grammar, arguments: {
        'lessonId': lesson.lessonId,
        'update': null,
        'status': -2,
        'classId': classId  });
    }
    if (type == HomeSkillType.reading) {
      Navigator.pushNamed(context, Routes.reading, arguments: {
        'lessonId': lesson.lessonId,
        'update': null,
        'status': -2,
        'classId': classId
      });
    }
  }
}
