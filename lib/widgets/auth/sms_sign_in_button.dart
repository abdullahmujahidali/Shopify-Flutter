import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _size = 50.0;

class SignInButtonSms extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButtonSms({
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
        ),
        child: Container(
          width: _size,
          height: _size,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.lightBlue.shade50,
          ),
          child: const Icon(
            CupertinoIcons.phone_fill,
            color: Colors.lightBlue,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}
