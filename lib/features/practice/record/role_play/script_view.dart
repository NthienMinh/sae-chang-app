import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/models/base_model/role_play_sentence_model.dart';
import '../../question_custom.dart';

class ScriptView extends StatelessWidget {
  ScriptView(
      {super.key, required this.soundCubit, required this.sentences}) : scriptCubit = ScriptCubit();

  final SoundCubit soundCubit;
  final List<RolePlaySentenceModel> sentences;
  final ScriptCubit scriptCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScriptCubit, String>(
      bloc: scriptCubit..update(sentences.first.sentence),
      builder: (context, state) {
        return BlocBuilder<SoundCubit, double>(
            bloc: soundCubit,
            builder: (c, double position) {
              var s = sentences.fold(sentences.first,
                      (pre, e) => e.position <= position ? e : pre);
              debugPrint('=>>>>>>>>>>>>>>>>>positionL $position');
              if(position > 0) {
                scriptCubit.update(s.sentence);
              }
              return QuestionCustom(question: state,);
            });
      },
    );
  }
}

class ScriptCubit extends Cubit<String> {
  ScriptCubit() : super('');


  update(String value) async {

    Functions.logDebug(value);
    emit(value);
  }
}
