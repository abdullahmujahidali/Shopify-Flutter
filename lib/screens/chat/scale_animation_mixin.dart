import 'package:flutter/cupertino.dart';

mixin ScaleAnimationMixin<T extends StatefulWidget> on State<T> {
  late final AnimationController scaleAnimationController;
  late final Animation<double> scaleAnimation;

  TickerProvider get vsync;

  @override
  void initState() {
    super.initState();
    scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: vsync,
      value: 1,
    );
    scaleAnimation = CurvedAnimation(
      parent: scaleAnimationController,
      curve: Curves.easeInBack,
    );

    scaleAnimationController.forward();
  }

  @override
  void dispose() {
    scaleAnimationController.dispose();
    super.dispose();
  }
}
