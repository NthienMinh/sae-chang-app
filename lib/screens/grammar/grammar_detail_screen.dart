import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/detail_class/lessons/grammar/note_view.dart';
import 'package:sae_chang/features/detail_class/lessons/grammar/signal_view.dart';
import 'package:sae_chang/features/detail_class/lessons/grammar/structures_view.dart';
import 'package:sae_chang/features/detail_class/lessons/grammar/user_view.dart';
import 'package:sae_chang/models/skill_models/grammar.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';

class GrammarDetailScreen extends StatelessWidget {
  const GrammarDetailScreen(
      {super.key,
        required this.grammar,
        required this.lessonId,
        required this.grammars});
  final Grammar grammar;
  final int lessonId;
  final List<Grammar> grammars;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GrammarDetailCubit(lessonId, grammar)..load(),
      child: BlocBuilder<GrammarDetailCubit, int>(
        builder: (context, state) {
          final cubit = context.read<GrammarDetailCubit>();
          return Scaffold(
            appBar: AppBarTemplate(grammar.mean.toUpperCase().replaceAll("{", "").replaceAll("}", ""), context),
            body: SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        bodyDetailGrammar(context, grammar),
                        SizedBox(
                          height: Resizable.padding(context, 120),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bodyDetailGrammar(BuildContext context, Grammar grammar) {
    var isTablet = Resizable.isTablet(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isTablet
              ? Resizable.padding(context, 30)
              : Resizable.padding(context, 20))
          .copyWith(bottom: 55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Resizable.padding(context, 30),
          ),
          grammar.structure.isEmpty
              ? Container()
              : StructuresView(grammar.structure),
          grammar.uses.isEmpty ? Container() : UsesView(grammar.uses),
          grammar.note.isEmpty ? Container() : NoteView(grammar.note),
          grammar.signal.isEmpty ? Container() : SignalView(grammar.signal),
        ],
      ),
    );
  }
}

class GrammarDetailCubit extends Cubit<int> {
  GrammarDetailCubit(this.lessonId, this.grammar) : super(0);
  final int lessonId;
  final Grammar grammar;


  load() async {

    emit(state + 1);
  }

}