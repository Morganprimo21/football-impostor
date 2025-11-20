import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleTapDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback onDoubleTap;

  const DoubleTapDetector(
      {Key? key, required this.child, required this.onDoubleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () {
        HapticFeedback.vibrate();
        onDoubleTap();
      },
      child: child,
    );
  }
}
