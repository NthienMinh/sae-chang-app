import 'package:equatable/equatable.dart';
import 'package:flutter/Material.dart';

abstract class PracticeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartEvent extends PracticeEvent {
  final int id, numOfQuestion, dataId,resultId, classId, userId;
  final String type;
  final BuildContext context;
  final bool isOffline;
  final bool isDoAgain;
  final int? level;
  StartEvent(this.classId, this.userId,this.id,this.dataId,this.resultId, this.type, this.context, this.isOffline , this.numOfQuestion, { this.isDoAgain = false, this.level});
}

class SubmitEvent extends PracticeEvent {
  final int id, timePractice, resultId;
  final String type;
  final BuildContext context;
  SubmitEvent(this.context ,this.id,this.resultId, this.timePractice, this.type);
}

class NextEvent extends PracticeEvent {
}

class PreviousEvent extends PracticeEvent {}

class UpdateEvent extends PracticeEvent {}
class UpdateDrawEvent extends PracticeEvent {
  final bool value;
  UpdateDrawEvent(this.value);
}

class JumpEvent extends PracticeEvent {
  final int index;
  JumpEvent(this.index);
}



// class AnswerEvent extends PracticeEvent {
//   final String answered;
//   final List<String> listImagePath;
//   final List<String> listImageFileName;
//   final List<String> listVoiceRecordPath;
//
//   AnswerEvent(this.answered, this.listImageFileName, this.listImagePath,
//       this.listVoiceRecordPath);
// }
