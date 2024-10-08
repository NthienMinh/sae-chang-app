import 'package:flutter/Material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class FlipTitle extends StatelessWidget {
  const FlipTitle({super.key, required this.isFront});
  final bool isFront;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Resizable.padding(context,10)
      ),
      child: Text("Bấm một lần để lật mặt ${isFront? 'sau' : 'trước'}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xffbdbdbd),
              fontStyle: FontStyle.italic,
              fontSize: Resizable.font(context, 12))),
    );
  }
}