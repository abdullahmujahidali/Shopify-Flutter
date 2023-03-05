import 'package:flutter/material.dart';

/// Use to place
class DragHandler extends StatelessWidget {
  const DragHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.center,
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(16.0),
            ),
          )
        ],
      ),
    );
  }
}
