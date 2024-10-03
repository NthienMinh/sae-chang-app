import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sae_chang/configs/color_configs.dart';


class LoadingProgress extends StatelessWidget {
  const LoadingProgress({super.key, this.color = primaryColor});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SizedBox(
          child: SpinKitCircle(
            color: color,
            size: 50.0,
            duration: const Duration(seconds: 1),
          )),
    );
  }
}
