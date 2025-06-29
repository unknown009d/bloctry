import 'package:bloctry/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialKey extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const DialKey({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<DialKey> createState() => _DialKeyState();
}

class _DialKeyState extends State<DialKey> {
  bool _isPressed = false;

  void _pressDown() {
    setState(() => _isPressed = true);
    HapticFeedback.vibrate();
  }

  void _pressUp() {
    widget.onPressed();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    const double size = 72;

    final duration = _isPressed
        ? Duration.zero
        : const Duration(milliseconds: 400);

    return Listener(
      onPointerDown: (_) => _pressDown(),
      onPointerUp: (_) => _pressUp(),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: duration,
        curve: _isPressed ? Curves.easeIn : Curves.easeOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.primaryRed : const Color(0x13FFFFFF),
          borderRadius: BorderRadius.circular(_isPressed ? size / 2 : 20),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 24,
            color: _isPressed ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
