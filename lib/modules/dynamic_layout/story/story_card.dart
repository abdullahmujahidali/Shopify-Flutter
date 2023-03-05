import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show StringExtensions;

import '../../../common/tools/navigate_tools.dart';
import '../../../widgets/common/flux_image.dart';
import 'models/story.dart';
import 'story_constants.dart';
import 'widgets/story_text.dart';

class StoryCard extends StatefulWidget {
  final double? width;
  final Story? story;
  final double? ratioWidth;
  final double? ratioHeight;
  final BuildContext? buildContext;

  const StoryCard({
    Key? key,
    this.story,
    this.width,
    this.ratioWidth,
    this.ratioHeight,
    this.buildContext,
  }) : super(key: key);

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  double? _width;
  double _opacity = 1;

  @override
  void initState() {
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        setState(() {
          _opacity = 1;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        _width = widget.width ?? constraint.maxWidth;
        final ratioWidth = widget.ratioWidth ?? 1.0;
        final ratioHeight = widget.ratioHeight ?? 1.0;
        final story = widget.story;
        return SizedBox(
          width: constraint.maxWidth,
          height: constraint.maxHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              story?.urlImage?.isURLImage ?? false
                  ? FluxImage(
                      imageUrl: story!.urlImage!,
                      key: const ValueKey(StoryConstants.backgroundKey),
                      fit: BoxFit.cover,
                    )
                  : const Placeholder(),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16 / ratioWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      story?.contents?.length ?? 0,
                      (int index) {
                        final padding =
                            story?.contents?[index].spacing?.padding ??
                                EdgeInsets.zero;
                        final margin =
                            story?.contents?[index].spacing?.margin ??
                                EdgeInsets.zero;

                        return Padding(
                          padding: story!.contents![index].getPadding(_width) ??
                              const EdgeInsets.only(),
                          child: Container(
                            key: ValueKey(
                                '${StoryConstants.storyItemKey}$index'),
                            width: _width,
                            padding: padding.copyWith(
                              left: padding.left / ratioWidth,
                              right: padding.right / ratioWidth,
                              top: padding.top / ratioHeight,
                              bottom: padding.bottom / ratioHeight,
                            ),
                            margin: margin.copyWith(
                              left: margin.left / ratioWidth,
                              right: margin.right / ratioWidth,
                              top: margin.top / ratioHeight,
                              bottom: margin.bottom / ratioHeight,
                            ),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 800),
                              opacity: _opacity,
                              child: GestureDetector(
                                key: ValueKey(
                                  '${StoryConstants.keyTextOfCardStory}$index',
                                ),
                                onTap: () {
                                  // ignore: omit_local_variable_types
                                  final Map config = {};
                                  if (story.contents?[index].link?.type ==
                                      'category') {
                                    config['category'] =
                                        story.contents?[index].link?.value;
                                    if (story.contents![index].link?.tag
                                            ?.isNotEmpty ??
                                        false) {
                                      config['tag'] = int.parse(
                                          story.contents![index].link!.tag!);
                                    }
                                  } else if (story
                                          .contents![index].link?.isNotEmpty ??
                                      false) {
                                    config[story.contents![index].link!.type] =
                                        story.contents![index].link!.value;
                                  }
                                  var popLayout = config['tab'] != null ||
                                      config['tab_number'] != null ||
                                      config['screen'] != null;
                                  NavigateTools.onTapNavigateOptions(
                                    context: context,
                                    config: config,
                                  ).then((value) {
                                    if (popLayout &&
                                        Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: StoryText(
                                  widget.story!.contents![index],
                                  key: ValueKey(
                                      '${StoryConstants.textKey}$index'),
                                  ratioWidth: ratioWidth,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
