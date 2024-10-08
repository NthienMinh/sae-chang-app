import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class CustomCardSide extends StatelessWidget {
  final Widget child;
  final bool isBack;

   const CustomCardSide({super.key,required this.child, this.isBack = false});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        shadowColor: primaryColor,
        elevation: Resizable.size(context, 5),
        margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 30)),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(Resizable.size(context, 30))),
            side: const BorderSide(color: primaryColor, width: 1)),
        child: child);
  }
}
