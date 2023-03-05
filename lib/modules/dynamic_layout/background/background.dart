import 'package:flutter/material.dart';
import 'package:inspireui/utils/colors.dart';

import '../../../widgets/common/index.dart';
import '../config/background_config.dart';

class HomeBackground extends StatelessWidget {
  final BackgroundConfig? config;

  const HomeBackground({required this.config});

  @override
  Widget build(BuildContext context) {
    if (config == null) {
      return const SizedBox();
    }

    if (config!.image == null && config!.color != null) {
      return Container(
        color: HexColor(config!.color),
        height: MediaQuery.of(context).size.height * config!.height,
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * config!.height,
      decoration: BoxDecoration(
        color: config?.color != null
            ? HexColor(config!.color)
            : Theme.of(context).primaryColor,
      ),
      child: config?.image != null
          ? FluxImage(
              imageUrl: config!.image!,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            )
          : const SizedBox(),
    );
  }
}
