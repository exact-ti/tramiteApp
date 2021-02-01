import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationType { opacity, translateX }

class FadeAnimationWidget extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimationWidget(this.delay, this.child, {AssetImage image});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationType >()
      ..add(AnimationType.opacity, Tween(begin: 0.0, end: 1.0),
          Duration(milliseconds: 500),)
      ..add(
        AnimationType.translateX,
        Tween(begin: 30.0, end: 1.0),
        Duration(milliseconds: 500),
      );


    return PlayAnimation<MultiTweenValues<AnimationType >>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AnimationType .opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AnimationType.translateX)), child: child),
      ),
    );
  }
}
