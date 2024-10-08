import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/home/home_title_category.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/progress_score.dart';
import 'package:sae_chang/widgets/shadow_text.dart';

import 'lesson_force_item.dart';

class LessonForceView extends StatelessWidget {
  const LessonForceView(
      {super.key,
      required this.lesson,
      required this.classModel,
      this.status,
      required this.teacherNote,
      required this.reload,
      required this.userId,
      required this.resultId});

  final LessonModel lesson;
  final ClassModel classModel;
  final dynamic status;
  final String teacherNote;
  final Function() reload;
  final int userId, resultId;

  bool checkIsEmpty() {
    return !lesson.skills.contains("btvn") &&
        !lesson.skills.contains("flashcard");
  }

  @override
  Widget build(BuildContext context) {
    return checkIsEmpty()
        ? Container()
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 20)),
                  child: HomeTitleCategory(
                      AppText.txtForce.text, 'assets/icons/ic_must.png'),
                ),
                if (lesson.skills.contains("flashcard"))
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    child: LessonForceItem(
                        onTap: () => Navigator.of(context, rootNavigator: true)
                                .pushNamed(Routes.flashCard, arguments: {
                              'lesson': lesson,
                              'class': classModel
                            }),
                        isDone: false,
                        widget: Container(),
                        title: AppText.txtFlashcard.text,
                        desc: 'Hãy ôn lại bài để có thể nhớ bài hơn nhé!',
                        status: AppText.txtNotDonePractice.text
                        // state == -1
                        //     ? AppText.txtDonePractice.text
                        //     : AppText.txtNotDonePractice.text
                        ),
                  ),
                if (lesson.skills.contains("btvn"))
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    child: BlocProvider(
                        create: (context) => StatusCubit()..load(status),
                        child: BlocBuilder<StatusCubit, dynamic>(
                            builder: (cc, state) {
                          final cubit = cc.read<StatusCubit>();
                          return LessonForceItem(
                              onTap: () async {
                                if (state == -2 || state == null) {
                                  final res = await Navigator.pushNamed(
                                      context, Routes.practice,
                                      arguments: {
                                        'id': lesson.lessonId,
                                        'type': "btvn",
                                        'resultId': resultId,
                                        'dataId': lesson.lessonId,
                                        'isOffline': false,
                                        'duration': 0,
                                        'userId': userId,
                                        'classId': classModel.classId
                                      });

                                  if (res != null &&
                                      res is Map<String, dynamic> &&
                                      res['complete'] == true) {
                                    reload();
                                    cubit.update(res['score'] ?? -1.0);
                                  }
                                } else {
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(Routes.result, arguments: {
                                    'id': lesson.lessonId,
                                    'type': "btvn",
                                    'resultId': resultId,
                                    'dataId': lesson.lessonId,
                                    'isOffline': false,
                                    'userId': userId,
                                    'classId': classModel.classId,
                                    'score': state
                                  });
                                }
                              },
                              isDone:
                                  (state == -2 || state == null) ? false : true,
                              title: AppText.txtHomework.text,
                              desc: AppText.txtLetPractice.text,
                              status: state == -2 || state == null
                                  ? AppText.txtNotDonePractice.text
                                      .toUpperCase()
                                  : AppText.txtDonePractice.text.toUpperCase(),
                              widget: (state == -2 || state == null)
                                  ? Container()
                                  : state == -1
                                      ? Image.asset(
                                          'assets/icons/ic_clock_wait.png',
                                          color: primaryColor,
                                          width: Resizable.size(context, 60),
                                          height: Resizable.size(context, 60))
                                      : ProgressScore(
                                          weight: Resizable.size(context, 4),
                                          fontScore:
                                              Resizable.font(context, 18),
                                          fontText: Resizable.font(context, 10),
                                          result: state,
                                          size: Resizable.size(context, 70)));
                        })),
                  ),
                if (teacherNote != "")
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 25),
                        vertical: Resizable.padding(context, 10),
                      ),
                      decoration: BoxDecoration(
                          color: const Color(0xffE0E0E0),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 10),
                          horizontal: Resizable.padding(context, 25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShadowText(AppText.txtTeacherNote.text,
                              color: primaryColor,
                              shadowColor: primaryColor,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 18),
                                  fontWeight: FontWeight.w700,
                                  color: darkRedColor)),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 10)),
                              child: Text(teacherNote,
                                  style: TextStyle(
                                      fontSize: Resizable.font(context, 12),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)))
                        ],
                      ))
              ],
            ),
          );
  }
}

class StatusCubit extends Cubit<dynamic> {
  StatusCubit() : super(null);

  load(dynamic s) {
    emit(s);
  }

  update(dynamic value) {
    emit(value);
  }
}
