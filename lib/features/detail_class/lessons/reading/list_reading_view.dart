

import 'package:flutter/Material.dart';
import 'package:sae_chang/features/detail_class/lessons/reading/reading_item.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:lifecycle/lifecycle.dart';

class ListViewReading extends StatefulWidget {
  const ListViewReading({super.key, required this.listReading, required this.timeCubit});
  final List<Reading> listReading;
  final TimeCustomCubit timeCubit;

  @override
  State<ListViewReading> createState() => _ListViewReadingState();
}

class _ListViewReadingState extends State<ListViewReading>  with LifecycleAware, LifecycleMixin  {
  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if(event == LifecycleEvent.push || event == LifecycleEvent.visible || event == LifecycleEvent.active) {
      widget.timeCubit.startTimer();
    }
    else {
      await widget.timeCubit.stopTimer();
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding:  EdgeInsets.symmetric(vertical: Resizable.padding(context, 30), horizontal: 0),
        itemCount: widget.listReading.length,
        itemBuilder: (context, index) {
          return ReadingItem(reading: widget.listReading[index]);
        });
  }
}
