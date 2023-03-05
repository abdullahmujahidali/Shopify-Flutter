import 'package:flutter/material.dart';

class QuickLinksWidget extends StatelessWidget {
  const QuickLinksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Quick Link',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _renderButton(
            'Contact Us',
          ),
          _renderButton(
            'Privacy Policy',
          ),
          _renderButton(
            'Terms & Conditions',
          ),
          _renderButton(
            'Abouts Us',
          ),
        ],
      ),
    );
  }

  Widget _renderButton(String title, {Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
        ),
      ),
    );
  }
}
