import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/models/skill_models/lesson.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:lifecycle/lifecycle.dart';

import 'lesson_item.dart';

class LessonListView extends StatefulWidget {
  const LessonListView({super.key, required this.listLessons, required this.lessonId, required this.timeCubit});
  final List<Lesson> listLessons;
  final int lessonId;
  final TimeCustomCubit timeCubit;

  @override
  State<LessonListView> createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> with LifecycleAware, LifecycleMixin  {
  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if(event == LifecycleEvent.push || event == LifecycleEvent.visible || event == LifecycleEvent.active) {
      widget.timeCubit.startTimer();
    }
    else {
      await widget.timeCubit.stopTimer();
    }
  }
  @override
  Widget build(BuildContext context) {
    var isTablet = Resizable.isTablet(context);
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 30),
        itemCount: widget.listLessons.length,
        itemBuilder: (context, idx) {
          return Container(
              constraints: const BoxConstraints(
                  minHeight: 55
              ),
              margin:  EdgeInsets.symmetric(
                  vertical: 5, horizontal: isTablet ? 30 : 15),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: primaryColor, width: 1),
              ),

              child: LessonItem(
                lesson: widget.listLessons[idx],)
          );
        });
  }
}
