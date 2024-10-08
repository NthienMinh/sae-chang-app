import 'package:flutter/Material.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/vocabulary/voca_item.dart';
import 'package:sae_chang/features/detail_class/lessons/vocabulary/vocabulary_cubit.dart';
import 'package:sae_chang/models/skill_models/word.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:lifecycle/lifecycle.dart';

class ListVocabularyView extends StatefulWidget {
  const ListVocabularyView(
      {super.key,
      required this.listWord,
      required this.timeCubit,
      required this.cubit});
  final List<Word> listWord;
  final TimeCustomCubit timeCubit;
  final VocabularyCubit cubit;
  @override
  State<ListVocabularyView> createState() => _ListVocabularyViewState();
}

class _ListVocabularyViewState extends State<ListVocabularyView>
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 15),
            vertical: Resizable.padding(context, 10)),
        child: Column(
          children: [
            ...widget.listWord
                .map((e) => VocaItem(word: e, cubit: widget.cubit))
          ],
        ),
      ),
    );
  }
}
