import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';

class BrandItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Skeleton(
              height: 60,
              width: 60,
            ),
            Skeleton(
              height: 20,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}
