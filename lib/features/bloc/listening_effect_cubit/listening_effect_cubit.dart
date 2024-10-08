
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sae_chang/providers/download/listening_provider.dart';
import 'package:sae_chang/services/media_service.dart';

part 'listening_effect_state.dart';

class ListeningEffectCubit extends Cubit<ListeningEffectState> {
  ListeningEffectCubit() : super(ListeningEffectInitial());
  final repo = ListeningProvider.instance;

  void load() async {
    final isBlur = await repo.getBlur();
    final isTranslate = await repo.getTranslate();
    final isPhonetic = await repo.getPhonetic();
    final isFurigana = await repo.getFurigana();
    emit(ListeningEffectLoaded(
        isBlur: isBlur,
        isSpeed: false,
        isPhonetic: isPhonetic,
        isFurigana: isFurigana,
        isTranslate: isTranslate));
  }

  void updateEffect(int index) async {
    if (state is ListeningEffectLoaded) {
      var stateNow = state as ListeningEffectLoaded;
      if (index == 1) {
        await repo.setBlur(!stateNow.isBlur);
        emit(stateNow.copyWith(isBlur: !stateNow.isBlur));
      } else if (index == 2) {
        await repo.setTranslate(!stateNow.isTranslate);
        emit(stateNow.copyWith(isTranslate: !stateNow.isTranslate));
      } else if (index == 3) {
        var isPhonetic = !stateNow.isPhonetic;
        await repo.setPhonetic(isPhonetic);
        if (isPhonetic) {
          await repo.setFurigana(false);
          emit(stateNow.copyWith(isFurigana: false, isPhonetic: true));
        } else {
          emit(stateNow.copyWith(isPhonetic: isPhonetic));
        }
      } else if (index == 4) {
        var isSpeed = !stateNow.isSpeed;
        await MediaService.instance.setSpeed(isSpeed ? 2 : 1);
        emit(stateNow.copyWith(isSpeed: !stateNow.isSpeed));
      } else {
        var isFurigana = !stateNow.isFurigana;
        await repo.setFurigana(isFurigana);
        if (isFurigana) {
          await repo.setPhonetic(false);
          emit(stateNow.copyWith(isPhonetic: false, isFurigana: true));
        } else {
          emit(stateNow.copyWith(isFurigana: isFurigana));
        }
      }
    }
  }
}
