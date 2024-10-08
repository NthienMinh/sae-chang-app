import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/listening_effect_cubit/listening_effect_cubit.dart';


class CircleButtonEffect extends StatelessWidget {
  const CircleButtonEffect(
      {super.key, required this.asset, required this.color, required this.index});
  final String asset;
  final Color color;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ListeningEffectCubit>(context).updateEffect(index);
      },
      borderRadius: BorderRadius.circular(1000),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0.0, 3.0),
              spreadRadius: 2,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            asset,
            color: color,
            fit: BoxFit.fill,
            height: 30,
            width: 30,
          ),
        ),
      ),
    );
  }
}
