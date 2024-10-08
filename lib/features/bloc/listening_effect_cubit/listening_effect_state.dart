part of 'listening_effect_cubit.dart';

abstract class ListeningEffectState extends Equatable {
  const ListeningEffectState();
}

class ListeningEffectInitial extends ListeningEffectState {
  @override
  List<Object> get props => [];
}

class ListeningEffectLoaded extends ListeningEffectState {
  const ListeningEffectLoaded(
      {required this.isBlur,
      required this.isSpeed,
      required this.isPhonetic,
      required this.isFurigana,
      required this.isTranslate});

  final bool isBlur;
  final bool isSpeed;
  final bool isPhonetic;
  final bool isTranslate;
  final bool isFurigana;
  ListeningEffectLoaded copyWith({
    bool? isBlur,
    bool? isSpeed,
    bool? isPhonetic,
    bool? isTranslate,
    bool? isFurigana,
  }) {
    return ListeningEffectLoaded(
      isBlur: isBlur ?? this.isBlur,
      isSpeed: isSpeed ?? this.isSpeed,
      isPhonetic: isPhonetic ?? this.isPhonetic,
      isTranslate: isTranslate ?? this.isTranslate,
      isFurigana: isFurigana ?? this.isFurigana,
    );
  }
  @override
  List<Object> get props => [isBlur, isSpeed, isPhonetic, isTranslate,isFurigana];
}
