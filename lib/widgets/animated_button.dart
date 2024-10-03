import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({super.key, required this.child});
  final Widget child;
  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  void _onPressedDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPressedUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPressedDown,
      onPointerUp: _onPressedUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Transform.scale(
          scale: _isPressed ? 0.9 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}
