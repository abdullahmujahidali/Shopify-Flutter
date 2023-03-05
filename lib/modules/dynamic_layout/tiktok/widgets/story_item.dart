import 'package:flutter/material.dart';
import '../../../../screens/detail/widgets/video_feature.dart';
import '../../../tiktok/index.dart';

class TikTokPlayerItem extends StatelessWidget {
  final TikTokVideoInfo item;

  const TikTokPlayerItem(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? aspectRatio;
    if (item.video != null &&
        item.video!.width != null &&
        item.video!.height != null) {
      aspectRatio = item.video!.width! / item.video!.height!;
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FeatureVideoPlayer(
        '${item.videoUrl}&dummy=${DateTime.now().millisecondsSinceEpoch}',
        holdToPlayPause: true,
        tapToPlayPause: false,
        autoPlay: true,
        aspectRatio: aspectRatio,
      ),
    );
  }
}
