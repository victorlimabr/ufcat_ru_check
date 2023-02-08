import 'package:flutter/material.dart';

class RUCheckTransitions {
  static Widget rightToLeftSlide(Widget child, Animation<double> animation) {
    final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero);
    final offsetAnimation = tween.animate(animation);
    return SlideTransition(position: offsetAnimation, child: child);
  }

  static Widget leftToRightSlide(Widget child, Animation<double> animation) {
    final tween = Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero);
    final offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  }
}
