import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/listening_detail_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/slider_bar.dart';

import 'listening_detail_action.dart';

class AppbarDetailPlayer extends StatefulWidget {
  const AppbarDetailPlayer({super.key});

  @override
  State<AppbarDetailPlayer> createState() => _AppbarDetailPlayerState();
}

class _AppbarDetailPlayerState extends State<AppbarDetailPlayer> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        ListeningDetailAction(),
        SizedBox(
          height: 20,
        ),
        SliderBar(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  headerTitle(BuildContext context) {
    final lesson = context.read<ListeningDetailCubit>().lesson!;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: primaryColor,
                )),
          ),
        ),
        Expanded(
            flex: 3,
            child: Center(
                child: Text(
              lesson.mean,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ))),
        Expanded(child: Container())
      ],
    );
  }
}
