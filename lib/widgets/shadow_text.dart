import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';

class ShadowText extends StatelessWidget {
  const ShadowText(this.data,
      {super.key,
      this.style = const TextStyle(),
      this.color = primaryColor,
      this.shadowColor,
      this.shadow = 3});

  final String data;
  final TextStyle style;
  final Color color;
  final Color? shadowColor;
  final double shadow;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: shadow+2,
            left: shadow,
            child: Text(
              data,
              maxLines: 1,
              style: style.copyWith(
                color: (shadowColor ?? Colors.grey.shade800).withOpacity(0.5),
                decorationColor:
                    (shadowColor ?? Colors.grey.shade800).withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: shadow+2,
              top: shadow,
              bottom: shadow,
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: AutoSizeText(
                data,
                maxLines: 1,
                style: style.copyWith(
                  color: color,
                  // shadows: [Shadow(color: color, offset: const Offset(0, -2))],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}