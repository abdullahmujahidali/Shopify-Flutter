import 'package:flutter/material.dart';

import '../../../../common/config.dart';
import '../../common/flux_image.dart';

class FollowSocialWidget extends StatelessWidget {
  final Widget title;
  final Axis direction;
  final Function(String)? onTap;

  const FollowSocialWidget({
    Key? key,
    required this.title,
    this.direction = Axis.horizontal,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listSocialData = kAdvanceConfig.socialConnectUrls;
    if (listSocialData.isNotEmpty) {
      final listSocialWidget = <Widget>[];

      for (var social in listSocialData) {
        if ((social.name.isNotEmpty) &&
            (social.url.isNotEmpty) &&
            (social.icon.isNotEmpty)) {
          listSocialWidget.add(
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: InkWell(
                hoverColor: Colors.transparent,
                child: FluxImage(
                  imageUrl: social.icon,
                  width: 20,
                  height: 20,
                ),
                onTap: () => onTap?.call(social.url),
              ),
            ),
          );
        }
      }
      var items = [
        Padding(
          padding: const EdgeInsets.only(right: 3),
          child: title,
        ),
        Row(
          children: List.generate(
              listSocialWidget.length, (index) => listSocialWidget[index]),
        )
      ];

      var body;

      if (direction == Axis.horizontal) {
        body = Row(
          children: items,
        );
      } else {
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        );
      }

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: body,
      );
    }

    return const SizedBox();
  }
}
