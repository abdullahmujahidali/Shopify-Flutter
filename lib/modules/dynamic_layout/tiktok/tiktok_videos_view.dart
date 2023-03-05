import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../tiktok/index.dart';
import '../index.dart' show TikTokVideosConfig;
import 'widgets/story_item.dart';
import 'widgets/story_progress.dart';

class TikTokVideosView extends StatefulWidget {
  final int position;
  final List<TikTokVideoInfo> items;
  final TikTokVideosConfig config;

  const TikTokVideosView({
    required this.position,
    required this.items,
    required this.config,
  });

  @override
  State<TikTokVideosView> createState() => _StateTikTokVideosView();
}

class _StateTikTokVideosView extends State<TikTokVideosView>
    with SingleTickerProviderStateMixin {
  int page = 0;
  GlobalKey keyScaffold =
      GlobalKey(); // use for get devices position (FLUXBUILDER)

  @override
  void initState() {
    super.initState();

    page = widget.position;
  }

  void _onTap(details) {
    var x = details.globalPosition.dx;

    /// remove spacing in FluxBuilder
    var box = keyScaffold.currentContext?.findRenderObject() as RenderBox?;
    var position = box?.localToGlobal(Offset.zero);
    if (position != null) {
      var dx = position.dx;
      x = x - dx;
    }
    var mediaWidth = MediaQuery.of(context).size.width;
    if ((x - (mediaWidth / 2)) > 0) {
      if (page >= widget.items.length - 1) {
        Navigator.pop(context);
        return;
      }
      setState(() {
        page++;
      });
    } else {
      if (page == 0) return;
      setState(() {
        page--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: keyScaffold,
      body: Stack(
        children: [
          GestureDetector(
            onTapUp: _onTap,
            onLongPressUp: () {},
            child: TikTokPlayerItem(
              widget.items[page],
              key: Key('tiktok-${widget.items[page].id}'),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(
                    widget.items.length,
                    (index) => Expanded(
                      child: StoryProgressIndicator(
                        enable: page == index,
                        finished: page > index,
                        time: widget.items[page].duration,
                        onFinish: () {
                          if (page >= widget.items.length - 1) {
                            Navigator.pop(context);
                            return;
                          }
                          setState(() {
                            page++;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(40)),
                margin: const EdgeInsets.only(
                  right: 20,
                  bottom: 20,
                  left: 10,
                  top: 10,
                ),
                width: 40,
                height: 40,
                child: const Center(child: Icon(CupertinoIcons.back)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
