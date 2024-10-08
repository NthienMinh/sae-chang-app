import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/shared_preferences.dart';
import 'package:sae_chang/untils/btvn_utils.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/replace_text.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/untils/split_text.dart';
import 'package:sae_chang/widgets/custom_scroll_bar.dart';
import 'match_word_item.dart';
import 'result_word_matched.dart';

class MatchColumnView extends StatelessWidget {
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final JoinWordCubit joinWordCubit;
  final String type;
  final BtvnUtils btvnUtils;

  MatchColumnView(
      {super.key,
      required this.questionModel,
      required this.bloc,
      required this.type, required this.btvnUtils,})
      : joinWordCubit = JoinWordCubit();


  bool checkComplete() {
    return questionModel.answered.every((element) => element.contains('|'));
  }
  @override
  Widget build(BuildContext context) {

    var resultList = getData();
    return Column(
      children: [
        Expanded(
          child: Card(
            elevation: 5,
            margin:CustomPadding.questionCardPadding(context),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 20)),
                side: const BorderSide(color: Color(0xffE0E0E0), width: 1)),
            child: Center(
              child: BlocConsumer<JoinWordCubit, String>(
                bloc: joinWordCubit,
                listener: (context, state) {

                  var splitMap = SplitText().splitMatchColumn(state, '|');
                  if (splitMap.length == 2) {


                    questionModel.answered[questionModel.answered.indexOf(
                        questionModel.answered.firstWhere(
                            (element) => element.length == 1))] = convertResult(state);
                    Functions.logDebug(splitMap[1]);
                    questionModel.columA.removeWhere(
                            (element) => element == splitMap[0]);
                    questionModel.columB.removeWhere(
                            (element) => element == splitMap[1]);

                    Functions.logDebug('${questionModel.columA.length}');
                    bloc.add(UpdateEvent());
                    BaseSharedPreferences.savePracticeData(questionModel, type, bloc.id, bloc.resultId);
                    joinWordCubit.change("");

                    Functions.logDebug(questionModel.answered.join('----'));
                    if(checkComplete()) {
                      bloc.autoSkip(() {
                        btvnUtils.autoNext(context, questionModel.questionType, bloc.dataId, bloc.id, bloc.classId, bloc.userId, bloc.resultId);
                      });
                    }

                  }
                },
                builder: (ccc, sss) {
                  return CustomScrollBar(
                    child: Column(
                      children: [
                        for (var i in resultList)
                          if (i.length != 1)
                            Builder(
                              builder: (context) {
                                var splitMap = SplitText().splitMatchColumn(i, '|');
                                return GestureDetector(
                                  onTap: () {
                                    questionModel.columA.add(splitMap[0]);
                                    questionModel.columB.add(splitMap[1]);
                                    questionModel.answered[
                                        questionModel.answered.indexOf(i)] = "a";
                                    bloc.add(UpdateEvent());
                                    BaseSharedPreferences.savePracticeData(
                                        questionModel, type, bloc.id, bloc.resultId);

                                    bloc.stopTimer();
                                  },
                                  child: ResultWordMatched(
                                    splitMap:SplitText().splitMatchColumn(convertResult(i), '|'),
                                  ),
                                );
                              }
                            ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 5),
                              horizontal: Resizable.padding(context, 40)),
                          child: Builder(
                            builder: (context) {
                              var lengthA =  questionModel.columA.join("").length;
                              var lengthB =  questionModel.columB.join("").length;
                              var res = (lengthA / lengthB).toDouble();
                              bool isBiggerA = false;
                              bool isBiggerB = false;
                              if(res >= 2) {
                                isBiggerA = true;
                                isBiggerB = false;
                              }
                              else if (res <=0.5) {
                                isBiggerA = false;
                                isBiggerB = true;
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context ,c ) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ...questionModel.columA.map((e) =>
                                                GestureDetector(
                                                  onTap: () {
                                                    if (joinWordCubit.state == "" ||
                                                        questionModel.columA.contains(
                                                            joinWordCubit.state)) {
                                                      joinWordCubit.change(e);
                                                    } else {
                                                      joinWordCubit.change(
                                                          "$e|${joinWordCubit.state}");
                                                    }
                                                  },
                                                  child: MatchWordItem(
                                                    text: convertWord(e),
                                                    type: 'A',
                                                    maxWidth: c.maxWidth,
                                                    isBigger: isBiggerA,
                                                    isChoose: e == joinWordCubit.state,
                                                  ),
                                                ))
                                          ],
                                        );
                                      }
                                    ),
                                  ),
                                   SizedBox(width: Resizable.padding(context, 20),),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context ,c ) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            ...questionModel.columB.map(
                                              (e) => GestureDetector(
                                                onTap: () {
                                                  if (joinWordCubit.state == "" ||
                                                      questionModel.columB.contains(
                                                          joinWordCubit.state)) {
                                                    joinWordCubit.change(e);
                                                  } else {
                                                    joinWordCubit.change(
                                                        "${joinWordCubit.state}|$e");
                                                  }
                                                },
                                                child: MatchWordItem(
                                                  text: convertWord(e),
                                                  type: 'B',
                                                  maxWidth: c.maxWidth,
                                                  isBigger: isBiggerB,
                                                  isChoose: e == joinWordCubit.state,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                    ),
                                  )
                                ],
                              );
                            }
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: Resizable.height(context) * 0.05,)
      ],
    );
  }

  List<String> getData() {
    List<String> resultList = questionModel.answered;
    if (questionModel.answered.isEmpty) {
      List<String> splitList =
      ReplaceText.replaceCharacterJapan(questionModel.question)
          .replaceAll("-", "|")
          .split(";")
        ..removeWhere((element) =>  RegExp(r'^\s*$').hasMatch(element));
      for (int i = 0; i < splitList.length; i++) {
        resultList.add("$i");
      }
      questionModel.answered = resultList;
      List<String> temp0 = [];
      List<String> temp1 = [];
      for (var i in splitList) {
        List<String> splitList2 = SplitText().splitMatchColumn(i, '|');
        if(splitList2.length == 2) {
          temp0.add(splitList2[0].trim());
          temp1.add(splitList2[1].trim());
        }
      }
      temp0.shuffle();
      temp1.shuffle();
      questionModel.columA = temp0.asMap().entries.map((e) => '${e.key}/${e.value}').toList();
      questionModel.columB = temp1.asMap().entries.map((e) => '${e.key}/${e.value}').toList();
    } else {

      List<String> splitList =
      ReplaceText.replaceCharacterJapan(questionModel.question)
          .replaceAll("-", "|")
          .split(";")..removeWhere((element) =>  RegExp(r'^\s*$').hasMatch(element));
      List<String> temp0 = [];
      List<String> temp1 = [];
      for (var i in splitList) {
        List<String> splitList2 = SplitText().splitMatchColumn(i, '|');
        if(splitList2.length == 2) {
          temp0.add(splitList2[0].trim());
          temp1.add(splitList2[1].trim());
        }
      }
      for (var i in questionModel.answered) {
        var splitMap = SplitText().splitMatchColumn(i, '|');
        if (splitMap.length == 2) {
          List<String> tempList = [...splitMap];
          if (temp0.contains(tempList[0].trim())) {
            temp0.remove(tempList[0]);
          }
          if (temp1.contains(tempList[1].trim())) {
            temp1.remove(tempList[1]);
          }
        }
      }
      temp0.shuffle();
      temp1.shuffle();
      questionModel.columA = temp0.asMap().entries.map((e) => '${e.key}/${e.value}').toList();
      questionModel.columB = temp1.asMap().entries.map((e) => '${e.key}/${e.value}').toList();
    }

    return resultList;
  }


  String convertWord(String e){
    final split = e.split('/');
    if(split.length == 2) {
      return split[1];
    }
    return e;
  }

  String convertResult(String e){
    return e.replaceAll(RegExp(r'\b[0-9]+/\s*'), '');
  }
}

class JoinWordCubit extends Cubit<String> {
  JoinWordCubit() : super("") {
    debugPrint("==============>join word");
  }

  change(String text) {
    emit(text);
  }
}
