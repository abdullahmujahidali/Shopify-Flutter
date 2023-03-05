import 'package:flutter/material.dart';

import 'story_card.dart';
import 'story_constants.dart';
import 'widgets/page_indicator.dart';

class StoryCollection extends StatefulWidget {
  final List<StoryCard?> listStory;
  final int? pageCurrent;
  final bool? isHorizontal;
  final bool? showChat;
  final bool isTab;

  const StoryCollection({
    Key? key,
    required this.listStory,
    this.pageCurrent,
    this.showChat,
    this.isHorizontal = true,
    this.isTab = false,
  }) : super(key: key);
  @override
  State<StoryCollection> createState() => _StoryCollectionState();
}

class _StoryCollectionState extends State<StoryCollection> {
  PageController? _controller;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildPageStory() {
    if (widget.listStory.isEmpty) {
      return const Center(
        child: Text('Not found story'),
      );
    }
    _controller = PageController(
      initialPage: widget.pageCurrent ?? 0,
      keepPage: false,
    );

    return PageView.builder(
      scrollDirection: widget.isHorizontal! ? Axis.horizontal : Axis.vertical,
      controller: _controller,
      itemCount: widget.listStory.length,
      itemBuilder: (ct, index) {
        return widget.listStory[index]!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              _buildPageStory(),
              if (widget.isTab == false)
                Positioned(
                  top: 24,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: -10,
                          blurRadius: 7,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: IconButton(
                      key: const ValueKey(StoryConstants.storyKeyButtonClose),
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 28,
                      ),
                      enableFeedback: true,
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ),
              Positioned(
                top: 32,
                width: constraint.maxWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: ScrollingPageIndicator(
                    dotColor: Theme.of(context).colorScheme.secondary,
                    dotSelectedColor: Theme.of(context).primaryColor,
                    dotSize: 8,
                    dotSelectedSize: 14,
                    dotSpacing: 17,
                    controller: _controller,
                    itemCount: widget.listStory.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
