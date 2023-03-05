import 'package:flutter/material.dart';
import '../../../../common/constants.dart';
import '../../../../screens/detail/widgets/video_feature.dart';
import '../../../../widgets/common/index.dart';
import '../../../../widgets/html/index.dart';
import '../../../instagram/classes/metadata_item.dart';

enum StoryItemLayout {
  iframe,
  media,
  mediaWithCap,
}

class StoryItem extends StatelessWidget {
  final StoryItemLayout layout;
  final MetadataItem item;
  const StoryItem(this.item, {this.layout = StoryItemLayout.iframe, Key? key})
      : super(key: key);

  Widget renderLayout(context) {
    if ((item.video?.isNotEmpty ?? false) &&
        [StoryItemLayout.media, StoryItemLayout.mediaWithCap]
            .contains(layout) &&
        isDesktop) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
        ),
        child: const Center(
            child:
                Text('Video Player is not support for previewing on Desktop')),
      );
    }
    switch (layout) {
      case StoryItemLayout.media:
        {
          if (item.video?.isNotEmpty ?? false) {
            return FeatureVideoPlayer(
              item.video ?? '',
              autoPlay: true,
              holdToPlayPause: true,
              tapToPlayPause: false,
            );
          }
          if (item.image?.isEmpty ?? true) return const SizedBox();
          return FluxImage(
            imageUrl: item.image!,
            fit: BoxFit.fitHeight,
          );
        }
      case StoryItemLayout.mediaWithCap:
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((item.video?.isEmpty ?? true) &&
                    (item.image?.isNotEmpty ?? false))
                  FluxImage(
                    imageUrl: item.image!,
                    fit: BoxFit.fitHeight,
                  ),
                if (item.video?.isNotEmpty ?? false)
                  FeatureVideoPlayer(
                    item.video ?? '',
                    autoPlay: true,
                    holdToPlayPause: true,
                    tapToPlayPause: false,
                  ),
                const Spacer(),
                if (item.mediaCaption != null)
                  Text(item.mediaCaption.toString()),
                if (item.caption != null) Text(item.caption.toString()),
              ],
            ),
          ),
        );
      case StoryItemLayout.iframe:
      default:
        return SafeArea(
          child: isDesktop || kIsWeb
              ? WebView(
                  url: 'https://www.instagram.com/p/${item.code}/embed/',
                  appBar: AppBar(
                    leading: const SizedBox(),
                    backgroundColor: Theme.of(context).colorScheme.background,
                  ),
                )
              : HtmlWidget(
                  '<iframe src="https://www.instagram.com/p/${item.code}/embed/"></iframe>',
                ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: renderLayout(context),
    );
  }
}
