import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:lifecycle/lifecycle.dart';

import 'count_down_test_cubit.dart';


class CountDownClock extends StatelessWidget {
  const CountDownClock(
      {super.key, required this.duration, required this.testId, required this.onAutoSubmit});

  final int testId;
  final int duration;
  final Function() onAutoSubmit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountDownTestCubit(testId, duration, onAutoSubmit)..load(),
      child: BlocBuilder<CountDownTestCubit, int>(
        builder: (context, state) {
          final countdownTestCubit = context.read<CountDownTestCubit>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: Resizable.size(context, 10),
              ),
              CountDownText(cubit: countdownTestCubit,)
            ],
          );
        },
      ),
    );
  }
}


class CountDownText extends StatefulWidget {
  const CountDownText({super.key, required this.cubit});
  final CountDownTestCubit cubit;
  @override
  State<CountDownText> createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText> with LifecycleAware, LifecycleMixin {

  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if (event == LifecycleEvent.push ||
        event == LifecycleEvent.visible ||
        event == LifecycleEvent.active) {
      widget.cubit.startTimer();
    } else {
      widget.cubit.stopTimer();
      debugPrint('out screen');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Text(
      Functions.formattedTime(
          timeInSecond: widget.cubit.tempDuration),
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: Resizable.font(context, 16)),
    );
  }
}
