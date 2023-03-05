import 'package:flutter/material.dart';

class CommonSafeArea extends StatelessWidget {
  const CommonSafeArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: child,
    );
  }
}
