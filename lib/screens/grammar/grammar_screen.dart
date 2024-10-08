import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/grammar/grammar_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/grammar/list_grammar_view.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';
import 'package:sae_chang/widgets/loading_progress.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({
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
    return Scaffold(
        appBar: AppBarTemplate(AppText.txtGrammar.text.toUpperCase(), context),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GrammarCubit(context, lessonId)..getData(),
          ),
          BlocProvider(
              create: (context) =>
                  TimeCustomCubit(classId, lessonId, 'grammar')),
        ],
        child: BlocBuilder<GrammarCubit, int>(builder: (context, state) {
          final cubit = context.read<GrammarCubit>();
          final timeCubit = context.read<TimeCustomCubit>();
          if (state != 0) {
            return Stack(
              children: [
                ListViewGrammar(
                    listGrammar: cubit.listGrammars,
                    timeCubit: timeCubit,
                    lessonId: lessonId)
              ],
            );
          }
          return const LoadingProgress();
        }),
      ),
    );
  }
}
