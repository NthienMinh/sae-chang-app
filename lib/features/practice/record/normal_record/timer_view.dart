import 'dart:async';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/untils/resizable_utils.dart';



class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: key,
      create: (context) => TimerCubit()..startTimer(),
      child: BlocBuilder<TimerCubit, Duration>(
          builder: (c, s) {
            String twoDigits(int n) =>
                n.toString().padLeft(2, '0');
            final twoDigitMinutes = twoDigits(
                s.inMinutes.remainder(60));
            final twoDigitSeconds = twoDigits(
                s.inSeconds.remainder(60));
            return Text(
                "$twoDigitMinutes:$twoDigitSeconds",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:
                    Resizable.font(context, 40)));
          }),
    );
  }
}

class TimerCubit extends Cubit<Duration> {
  TimerCubit() :super(Duration.zero);

  Timer? _timer;
  int _countedSeconds = 0;
  Duration timedDuration = Duration.zero;

  void startTimer() {
    _timer?.cancel();
    _countedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countedSeconds++;
      timedDuration = Duration(seconds: _countedSeconds);
      if(isClosed) return;
      emit(timedDuration);
    });
  }
}
