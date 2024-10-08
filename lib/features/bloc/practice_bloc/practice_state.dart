import 'package:sae_chang/models/base_model/question_model.dart';

abstract class PracticeState {}

class LoadingState extends PracticeState {}

class SubmittingState extends PracticeState {}

class SubmittedState extends PracticeState {
  final Map<String, dynamic> result;
  SubmittedState(this.result);
}

class SubmitError extends PracticeState {
  final List<String> errorList;
  SubmitError(this.errorList);
}

class QuestionState extends PracticeState {
  final QuestionModel question;
  final List<QuestionModel> listQuestions;
  final List<QuestionModel> listIgnore;
  final int practiceIndex;
  final int count;
  QuestionState(this.listQuestions, this.listIgnore, this.question,
      this.practiceIndex, this.count);
}
