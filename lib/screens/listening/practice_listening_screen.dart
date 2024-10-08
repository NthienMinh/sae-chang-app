

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/lesson_list_view.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/listening_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';
import 'package:sae_chang/widgets/loading_progress.dart';

class PracticeListeningScreen extends StatelessWidget {
  const PracticeListeningScreen(
      {super.key,
      required this.lessonId,
      this.update, required this.status, required this.classId});
  final int lessonId;
  final Function()? update;
  final int status;
  final int classId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        AppText.txtListeningPractice.text.toUpperCase(),
        context,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ListeningCubit(
                context, lessonId)
              ..getData(),
          ),
          BlocProvider(
            create: (context) =>
                TimeCustomCubit(classId,lessonId, 'listening'),
          )
        ],
        child: BlocBuilder<ListeningCubit, int>(builder: (c, i) {
          final cubit = c.read<ListeningCubit>();
          final timeCubit = c.read<TimeCustomCubit>();
          return i == 0
              ? const LoadingProgress()
              : Stack(
                  children: [
                    LessonListView(
                      listLessons: cubit.listLessons!,
                      lessonId: lessonId,
                      timeCubit: timeCubit,
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
