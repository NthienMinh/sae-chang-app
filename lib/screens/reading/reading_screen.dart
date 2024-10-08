import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/reading/list_reading_view.dart';
import 'package:sae_chang/features/detail_class/lessons/reading/reading_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';
import 'package:sae_chang/widgets/loading_progress.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({
    super.key,
    required this.lessonId,
    this.update,
    required this.status, required this.classId,
  });

  final int lessonId;
  final Function()? update;
  final int status;
  final int classId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
          AppText.txtReading.text.toUpperCase(), context),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ReadingCubit(
                context, lessonId)
              ..getData(),
          ),
          BlocProvider(
            create: (context) =>
                TimeCustomCubit(classId,lessonId, 'reading' ),
          )
        ],
        child: BlocBuilder<ReadingCubit, int>(builder: (context, state) {
          final cubit = context.read<ReadingCubit>();
          final timeCubit = context.read<TimeCustomCubit>();
          if (state != 0) {
            return Stack(
              children: [
                ListViewReading(
                    listReading: cubit.listReading, timeCubit: timeCubit),
              ],
            );
          }
          return const LoadingProgress();
        }),
      ),
    );
  }
}