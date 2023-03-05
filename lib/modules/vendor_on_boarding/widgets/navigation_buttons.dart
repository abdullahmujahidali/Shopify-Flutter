import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final VoidCallback? onFinish;
  const NavigationButtons({Key? key, this.onNext, this.onBack, this.onFinish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = 20.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (onBack != null)
            CircleAvatar(
              radius: radius,
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: onBack,
              ),
            ),
          if (onBack == null) const SizedBox(width: 100),
          if (onNext != null)
            CircleAvatar(
              radius: radius,
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                onPressed: onNext,
              ),
            ),
          if (onFinish != null)
            CircleAvatar(
              radius: radius,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: onFinish,
              ),
            ),
          if (onNext == null && onFinish == null) const SizedBox(width: 50),
        ],
      ),
    );
  }
}
