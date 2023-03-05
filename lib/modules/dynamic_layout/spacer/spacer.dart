import 'package:flutter/material.dart';
import '../../../common/tools.dart';
import '../config/spacer_config.dart';

class SpacerLayout extends StatelessWidget {
  final SpacerConfig config;
  const SpacerLayout({required this.config, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = config.backgroundColor != null
        ? HexColor(config.backgroundColor)
        : Theme.of(context).colorScheme.background;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: config.height.toDouble(),
      color: config.useLightColor
          ? Theme.of(context).primaryColorLight
          : backgroundColor,
    );
  }
}
