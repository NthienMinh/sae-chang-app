import 'package:flutter/Material.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/models/skill_models/grammar.dart';
import 'package:lifecycle/lifecycle.dart';

import 'grammar_item.dart';

class ListViewGrammar extends StatefulWidget {
  const ListViewGrammar(
      {Key? key,
        required this.listGrammar,
        required this.timeCubit,
        required this.lessonId})
      : super(key: key);
  final List<Grammar> listGrammar;
  final TimeCustomCubit timeCubit;
  final int lessonId;

  @override
  State<ListViewGrammar> createState() => _ListViewGrammarState();
}

class _ListViewGrammarState extends State<ListViewGrammar>
    with LifecycleAware, LifecycleMixin {
  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if (event == LifecycleEvent.push ||
        event == LifecycleEvent.visible ||
        event == LifecycleEvent.active) {
      widget.timeCubit.startTimer();
    } else if (event == LifecycleEvent.pop) {
      await widget.timeCubit.stopTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
        itemCount: widget.listGrammar.length,
        itemBuilder: (context, index) {
          return GrammarItem(
              grammars: widget.listGrammar,
              grammar: widget.listGrammar[index],
              lessonId: widget.lessonId);
        });
  }
}