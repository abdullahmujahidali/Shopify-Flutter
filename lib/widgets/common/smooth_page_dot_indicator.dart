import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothPageDotIndicator extends SmoothPageIndicator {
  SmoothPageDotIndicator({
    required PageController controller,
    required int maxCount,
    Color colorActiveDotBorder = Colors.black,
    Color colorFillDot = Colors.black45,
    double sizeDot = 10,
    double sizeActiveDot = 10,
    double spacing = 8,
    double withActiveDotBorder = 1,
    double radius = 5,
  }) : super(
          controller: controller,
          count: maxCount,
          effect: CustomizableEffect(
            activeDotDecoration: DotDecoration(
              borderRadius: BorderRadius.circular(radius),
              dotBorder: DotBorder(
                  width: withActiveDotBorder, color: colorActiveDotBorder),
              width: sizeActiveDot,
              height: sizeActiveDot,
            ),
            spacing: spacing,
            dotDecoration: DotDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: colorFillDot,
              width: sizeDot,
              height: sizeDot,
            ),
          ),
        );
}
