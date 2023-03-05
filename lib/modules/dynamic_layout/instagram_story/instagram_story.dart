import 'package:flutter/material.dart';

import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/index.dart' hide WebView;
import '../../instagram/classes/metadata.dart';
import '../../instagram/classes/metadata_item.dart';
import '../../instagram/instagram_service.dart';
import '../config/instagram_story_config.dart';
import 'instagram_story_view.dart';

class InstagramStory extends StatefulWidget {
  final InstagramStoryConfig config;
  const InstagramStory({required this.config, Key? key}) : super(key: key);

  @override
  State<InstagramStory> createState() => _StateInstagramStory();
}

class _StateInstagramStory extends State<InstagramStory> {
  Metadata? metadata;
  int get length => metadata?.data.length ?? 0;
  int get limit => length > widget.config.limit ? widget.config.limit : length;
  List<MetadataItem>? get items => metadata?.data.sublist(0, limit);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        loadInit();
      }
    });
  }

  @override
  void didUpdateWidget(covariant InstagramStory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.toJson().toString() !=
        widget.config.toJson().toString()) {
      loadInit();
    }
  }

  void loadInit() async {
    /// load from Instagram API
    if ((widget.config.path?.isNotEmpty ?? false) && widget.config.usePath) {
      var data = await InstagramService.getMetadata(widget.config.path!);
      if (!data.loadFail) {
        setState(() {
          metadata = data;
        });
        return;
      }
    }

    /// load from data in config
    var metaItems = <MetadataItem>[];
    for (var item in widget.config.items) {
      metaItems.add(MetadataItem.fromConfig(item));
    }
    setState(() {
      metadata = Metadata(data: metaItems);
    });
  }

  Widget renderLayout() {
    if (metadata == null) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              4,
              (index) => InstagramStoryItem(
                    config: widget.config,
                  )),
        ),
      );
    }
    if (metadata?.loadFail ?? false) {
      return const SizedBox();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          items!.length,
          (index) => InstagramStoryItem(
            item: items?[index],
            config: widget.config,
            onTap: () => FluxNavigate.push(
              MaterialPageRoute(
                builder: (context) => InstagramStoryView(
                  position: index,
                  layout: widget.config.viewLayout,
                  time: widget.config.time,
                  items: items!,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.config.itemHeight.toDouble(),
      margin: EdgeInsets.only(
        left: widget.config.marginLeft.toDouble(),
        right: widget.config.marginRight.toDouble(),
        top: widget.config.marginTop.toDouble(),
        bottom: widget.config.marginBottom.toDouble(),
      ),
      child: renderLayout(),
    );
  }
}

class InstagramStoryItem extends StatelessWidget {
  final MetadataItem? item;
  final Function()? onTap;
  final InstagramStoryConfig config;
  const InstagramStoryItem({this.item, this.onTap, required this.config});

  @override
  Widget build(BuildContext context) {
    final imageHeight = config.itemHeight.toDouble();
    final imageWidth = config.itemWidth.toDouble();
    return Padding(
      padding: EdgeInsets.only(right: config.itemSpacing.toDouble()),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(config.itemBorderRadius.toDouble()),
        child: item == null
            ? Container(
                color: Theme.of(context).primaryColorLight,
                width: imageWidth,
                height: imageHeight,
              )
            : InkWell(
                onTap: onTap,
                child: Stack(
                  children: [
                    if (item?.image != null)
                      FluxImage(
                        imageUrl: item!.image!,
                        height: imageHeight,
                        width: imageWidth,
                        fit: BoxFit.fitHeight,
                      ),
                    Container(
                      height: imageHeight,
                      width: imageWidth,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2),
                    ),
                    if (item!.profileImage != null && !config.hideAvatar)
                      Container(
                        margin: const EdgeInsets.only(left: 2, top: 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).colorScheme.background,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: FluxImage(
                              imageUrl: item!.profileImage!,
                            ),
                          ),
                        ),
                      ),
                    if (item!.mediaCaption != null && !config.hideCaption)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: imageWidth,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text(
                            item!.mediaCaption!,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Theme.of(context).colorScheme.background),
                          ),
                        ),
                      )
                  ],
                ),
              ),
      ),
    );
  }
}
