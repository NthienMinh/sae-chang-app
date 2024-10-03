import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectCubit extends Cubit<bool> {
  static final ConnectCubit _instance = ConnectCubit._internal();

  static ConnectCubit get instance => _instance;

  ConnectCubit._internal() : super(true);

  init() {}

  dispose() {}

  update(bool value) {
    debugPrint("===========>connect state : $value");
    emit(value);
  }
}
