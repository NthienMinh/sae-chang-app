import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/vocabulary/list_vocabulary_view.dart';
import 'package:sae_chang/features/detail_class/lessons/vocabulary/vocabulary_cubit.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/dialogs.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';
import 'package:sae_chang/widgets/float_action_board.dart';
import 'package:sae_chang/widgets/loading_progress.dart';
import 'package:sae_chang/widgets/sl_float_action_board.dart';

import '../../configs/text_configs.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({
    super.key,
    required this.lessonId,
    this.update,
    required this.status,
    required this.classId,
  });
  final int lessonId;
  final Function()? update;
  final int status;
  final int classId;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => VocabularyCubit(context, lessonId)..getData(),
        ),
        BlocProvider(
          create: (context) => TimeCustomCubit(classId, lessonId, 'vocabulary'),
        ),
      ],
      child: BlocBuilder<VocabularyCubit, int>(
        builder: (context, state) {
          final timeCubit = context.read<TimeCustomCubit>();
          final vocabularyCubit = context.read<VocabularyCubit>();
          return Scaffold(
            appBar: AppBarTemplate(
                AppText.txtVocabulary.text.toUpperCase(), context) ,
            body: state != 0 ?Stack(
              children: [
                ListVocabularyView(
                  listWord: vocabularyCubit.listWords,
                  cubit: vocabularyCubit,
                  timeCubit: timeCubit,
                ),
                if (vocabularyCubit.listWords.isNotEmpty)
                  SlFloatActionBoard(
                    onPractice: () {
                      Dialogs.showDialogPractice(context , FloatActionBoard(
                        showFloatIcon: false,
                        onFlashcard: () async {
                          await Navigator.pushNamed(
                              context,
                              Routes.wordFlashcard,
                              arguments: {
                                'lessonId': vocabularyCubit
                                    .lessonId,
                                'listWord': vocabularyCubit.listWords
                              });
                        },
                      ));

                    }
                  ),
              ],
            )  : const LoadingProgress()

          );
        },
      ),
    );
  }
}
