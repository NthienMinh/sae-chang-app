import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared_preferences.dart';

class CaptureImageCubit extends Cubit<List<XFile>> {
  CaptureImageCubit({Key? key}) : super([]);

  load(List<XFile> files) {
    emit(files);
  }

  removePhoto(context,XFile file,QuestionModel questionModel, PracticeBloc bloc, String type)async {
    emit([...(state..remove(file))]);
    List<String> listPath = [];
    for(var i in state){
      listPath.add(i.path);
    }
    questionModel.answered = listPath;
    bloc.add(UpdateEvent());
    BaseSharedPreferences.savePracticeData(questionModel, type, bloc.id, bloc.resultId);
  }

  bool isTaking = false;


  takePhoto(context, source, QuestionModel questionModel, PracticeBloc bloc, String type) async {
    if (isTaking) return;

    isTaking = true;

    emit([...(state)]);

    await Future.delayed(const Duration(milliseconds: 500));

    XFile? image = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear);

    isTaking = false;

    if (image != null) {
      emit([...state, image]);

      List<String> listPath = [];
      for(var i in state){
        listPath.add(i.path);
      }
      questionModel.answered = listPath;
      debugPrint(listPath.toString());
      bloc.add(UpdateEvent());
      BaseSharedPreferences.savePracticeData(questionModel,type, bloc.id, bloc.resultId);
    } else {
      emit([...(state)]);
    }
  }
}
