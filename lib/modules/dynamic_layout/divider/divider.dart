import 'package:flutter/material.dart';
import '../../../common/tools.dart';
import '../config/divider_config.dart';

class DividerLayout extends StatelessWidget {
  final DividerConfig config;
  const DividerLayout({required this.config, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = config.color != null ? HexColor(config.color) : null;
    return Divider(
      height: config.thickness.toDouble(),
      thickness: config.thickness.toDouble(),
      indent: config.indent.toDouble(),
      endIndent: config.endIndent.toDouble(),
      color: color,
    );
  }
}
