import 'package:flutter/material.dart';

class WrapStatusBar extends StatelessWidget {
  final Color? color;

  const WrapStatusBar({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: color ?? Theme.of(context).colorScheme.background,
        child: const SafeArea(
          bottom: false,
          child: SizedBox(),
        ),
      ),
    );
  }
}
