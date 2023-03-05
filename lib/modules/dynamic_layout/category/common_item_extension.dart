import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import '../../../common/tools.dart';
import '../index.dart';

extension CommonItemExtension on CommonItemConfig {
  AlignmentGeometry get alignment => Tools.getAlignment(textAlignment);
  BoxFit get boxFit => ImageTools.boxFit(imageBoxFit);
  HexColor get borderColor => HexColor(imageBorderColor);
  ImageBorderStyle get borderStyle => ImageBorderStyle.values.firstWhere(
      (e) => e.toString().split('.').last == imageBorderStyle,
      orElse: () => ImageBorderStyle.solid);
  Decoration get imageDecoration => getImageDecoration();
  bool get hasBorder => imageBorderWidth != null && imageBorderWidth! > 0;
  Border? get imageBorder => hasBorder
      ? Border.all(
          width: imageBorderWidth!,
          color: borderColor,
        )
      : null;

  Decoration getImageDecoration() {
    if (borderStyle == ImageBorderStyle.dot && hasBorder) {
      return DottedDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0.0),
          shape: Shape.box,
          color: borderColor,
          dash: const [3, 3],
          strokeWidth: imageBorderWidth!);
    }
    return BoxDecoration(
      border: imageBorder,
      borderRadius: BorderRadius.circular(radius ?? 0.0),
    );
  }
}
