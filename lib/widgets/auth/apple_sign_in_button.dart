import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../data/boxes.dart';
import '../common/flux_image.dart';

const _size = 50.0;

class SignInButtonApple extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const SignInButtonApple({
    Key? key,
    this.enabled = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = SettingsBox().isDarkTheme ?? kDefaultDarkTheme;
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: isDarkTheme
          ? const FluxImage(
              imageUrl: 'assets/icons/logins/apple_white.svg',
              width: _size,
              height: _size,
            )
          : const FluxImage(
              imageUrl: 'assets/icons/logins/apple_black.svg',
              width: _size,
              height: _size,
            ),
    );
  }
}
