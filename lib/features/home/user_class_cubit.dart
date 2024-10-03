import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/course_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/shared_preferences.dart';

import '../../configs/prefKeys_configs.dart';
import '../bloc/connect_cubit.dart';

class UserClassCubit extends Cubit<int>{
  static final UserClassCubit _instance = UserClassCubit._internal();

  static UserClassCubit get instance => _instance;

  UserClassCubit._internal() : super(0);

  List<UserClassModel>? listUserClass;

  List<ClassModel> listClass = [];

  List<CourseModel> listCourse = [];

  bool isLoading = true;

  loadData()async{

    isLoading = true;

    emit(state+1);

    if(ConnectCubit.instance.state == false){
      listUserClass = [];
      emit(state+1);
      return;
    }

    listClass = [];
    listCourse = [];


    var userId = await BaseSharedPreferences.getIntValue(PrefKeyConfigs.userId);

    listUserClass = await FireBaseProvider.instance.getUserClass(userId!);

    List<int> ids = listUserClass!.map((e)=>e.classId).toSet().toList();

    listClass =  await FireBaseProvider.instance.getClassByIds(ids);

    List<int> listCourseId = listClass.map((e)=>e.courseId).toSet().toList();

    listCourse = await FireBaseProvider.instance.getCourseByIds(listCourseId);

    isLoading = false;

    emit(state+1);
  }

  clearData(){
    isLoading = true;
    listUserClass = null;
    listClass = [];
    listCourse = [];
    emit(state+1);
  }

  ClassModel getClass(int classId){
    var list = listClass.where((e)=>e.classId == classId);

    return list.first;
  }

  CourseModel? getCourse(int courseId){
    var list = listCourse.where((e)=>e.id == courseId);

    if(list.isEmpty) return null;
    return list.first;
  }

}