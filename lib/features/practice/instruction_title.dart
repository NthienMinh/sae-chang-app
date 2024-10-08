import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_state.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../widgets/split_text_custom.dart';


class InstructionTitle extends StatelessWidget {
  InstructionTitle({super.key, required this.state}) : instructionCubit = InstructionCubit();
  final QuestionState state;
  final InstructionCubit instructionCubit;
  @override
  Widget build(BuildContext context) {
    var isTablet = Resizable.isTablet(context);
    return   Container(
      margin: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 10),
          horizontal: Resizable.padding(context, isTablet ? 30 : 15)),
      child: LayoutBuilder(builder: (ctx, ct) {
        debugPrint(ct.maxWidth.toString());
        return BlocProvider.value(
          value: instructionCubit
            ..load(state.question.instruction, ct.maxWidth - 70,
                context),
          child: BlocBuilder<InstructionCubit, int>(
            builder: (context, i) {
              if (i == 0) return Container();
              final cubit = context.read<InstructionCubit>();
              return Row(
                crossAxisAlignment: cubit.isShowMore ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Platform.isAndroid
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: isTablet ? 35 : 25,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: SplitTextCustom(
                            text: state.question.instruction.trim(),
                            maxLines: cubit.isShowMore ? null : 1,
                            phoneticSize: Resizable.font(context, 10),
                            kanjiFW: FontWeight.w600,
                            kanjiColor: Colors.white,
                            phoneticColor: Colors.white,
                            kanjiSize: Resizable.font(context, 17)),
                      ),
                    ),
                  ),
                  cubit.isOneLine
                      ? SizedBox(
                    height: Resizable.size(context, 15),
                    width: isTablet ? 35 : 25,
                  )
                      : InkWell(
                    child: InkWell(
                      onTap: () {
                        cubit.update();
                      },
                      child: Container(
                        height: Resizable.size(context, 15),
                        width: isTablet ? 35 : 25,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(1000),
                            color: Colors.white),
                        child: Image.asset(
                          'assets/icons/ic_${!cubit.isShowMore ? 'more' : 'less'}_text.png',
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
class InstructionCubit extends Cubit<int> {
  InstructionCubit() : super(0);
  bool isOneLine = false;
  bool isShowMore = false;

  load(String text, double width, BuildContext context) {
    var style = TextStyle(
        fontSize: Resizable.font(context, 15), fontWeight: FontWeight.w500);
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: width);
    final numLines = tp.computeLineMetrics().length;
    isOneLine = numLines == 1;
    emit(state + 1);
  }

  update() {
    isShowMore = !isShowMore;
    emit(state + 1);
  }
}