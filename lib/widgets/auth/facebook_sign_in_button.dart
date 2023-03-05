import 'package:flutter/material.dart';

const _size = 50.0;

class SignInButtonFacebook extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButtonFacebook({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: _size,
        height: _size,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color(0xFF1877F2),
        ),
        child: const Icon(
          Icons.facebook_rounded,
          color: Colors.white,
          size: 28.0,
        ),
      ),
    );
  }
}
