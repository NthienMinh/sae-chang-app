import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/models/skill_models/reading.dart';

class ReadingDetailCubit extends Cubit<int> {
  ReadingDetailCubit(this.reading) : super(0);

  final Reading reading;
  bool translate = false;


  updateTranslate() {
    translate = !translate;
    emit(state + 1);
  }

}