import 'package:flutter/material.dart';

import '../../../constants.dart';

class RatingColor {
  final Color primaryStar;
  final Color borderStar;
  final Color primaryLinearProgress;
  final Color backgroundLinearProgress;

  RatingColor({
    this.primaryStar = const Color(0xfff39c12),
    this.borderStar = const Color(0xff3fc1be),
    this.primaryLinearProgress = const Color(0xfff39c12),
    this.backgroundLinearProgress = const Color(0xffF1F2F3),
  });

  factory RatingColor.fromJson(Map<String, dynamic> json) {
    return RatingColor(
      primaryStar: HexColor(json['primaryStar'] ?? 'f39c12'),
      borderStar: HexColor(
          json['borderStar'] ?? '3fc1be'),
      primaryLinearProgress:
          HexColor(json['primaryLinearProgress'] ?? 'f39c12'),
      backgroundLinearProgress:
          HexColor(json['backgroundLinearProgress'] ?? 'F1F2F3'),
    );
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['primaryStar'] = primaryStar.value.toRadixString(16);
    map['borderStar'] = borderStar.value.toRadixString(16);
    map['primaryLinearProgress'] =
        primaryLinearProgress.value.toRadixString(16);
    map['backgroundLinearProgress'] =
        backgroundLinearProgress.value.toRadixString(16);
    return map;
  }
}
