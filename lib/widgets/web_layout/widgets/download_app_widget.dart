import 'package:flutter/material.dart';

import '../../../../common/config.dart';
import '../../common/flux_image.dart';

class DownloadAppWidget extends StatelessWidget {
  final Function(String)? onTap;
  const DownloadAppWidget({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'DOWNLOAD OUR APP',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () => onTap?.call(kStoreIdentifier['android']),
                  child: const FluxImage(
                    width: 120,
                    imageUrl: 'assets/images/google-play-badge.png',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () => onTap?.call(kStoreIdentifier['ios']),
                  child: const FluxImage(
                    width: 145,
                    imageUrl: 'assets/images/apple-store-badge.svg',
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
