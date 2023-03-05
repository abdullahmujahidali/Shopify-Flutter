import 'package:flutter/material.dart';

class MyAccountWidget extends StatelessWidget {
  const MyAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'My Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _renderButton(
            'Profiles',
          ),
          _renderButton(
            'Address',
          ),
          _renderButton(
            'Live Chat',
          ),
          _renderButton(
            'My Order',
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
