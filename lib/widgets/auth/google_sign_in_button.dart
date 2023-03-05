import 'package:flutter/material.dart';

import '../common/flux_image.dart';

const _size = 50.0;

class SignInButtonGoogle extends StatefulWidget {
  final VoidCallback onPressed;

  const SignInButtonGoogle({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<SignInButtonGoogle> createState() => _SignInButtonGoogleState();
}

class _SignInButtonGoogleState extends State<SignInButtonGoogle> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _isHovering = true),
      onTapUp: (_) => setState(() => _isHovering = false),
      onTapCancel: () => setState(() => _isHovering = false),
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: _isHovering ? const Color(0xFFEEEEEE) : Colors.white,
          border: Border.all(
            color: const Color(0xFF4285F4),
            width: 1.5,
          ),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12.5),
        child: const FluxImage(
          imageUrl: 'assets/icons/logins/google.svg',
          width: 18,
          height: 18,
        ),
      ),
    );
  }
}
