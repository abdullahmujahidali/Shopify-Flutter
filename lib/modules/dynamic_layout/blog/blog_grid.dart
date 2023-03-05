import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show Skeleton;
import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';

import '../../../common/constants.dart';
import '../../../routes/flux_navigate.dart';
import '../../../screens/base_screen.dart';
import '../../../screens/blog/index.dart';
import '../../../widgets/blog/blog_grid_item.dart';
import '../helper/helper.dart';
import '../index.dart' show BlogConfig, HeaderView;

class BlogGrid extends StatefulWidget {
  final BlogConfig? config;

  const BlogGrid({
    Key? key,
    this.config,
  }) : super(key: key);

  @override
  BaseScreen<BlogGrid> createState() => _BlogGridState();
}

class _BlogGridState extends BaseScreen<BlogGrid> {
  PageController? pageController;
  final viewportFraction = 0.9;

  @override
  void initState() {
    pageController = PageController(viewportFraction: viewportFraction);
    super.initState();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  Widget _buildHeader(
    BuildContext context,
    List<Blog>? blogs, {
    double padding = 10,
  }) {
    if (widget.config?.name != null) {
      var showSeeAllLink = widget.config?.layout != 'instagram';
      return HeaderView(
        headerText: widget.config?.name ?? '',
        showSeeAll: showSeeAllLink,
        horizontalMargin: padding,
        callback: () => Navigator.of(context).pushNamed(RouteList.listBlog),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    var isDesktop = Layout.isDisplayDesktop(context);
    var isTablet = Helper.isTablet(MediaQuery.of(context));
    var offset = (widget.config?.innerPadding ?? 0.0) + 11;
    if ((widget.config?.hideDate ?? true) &&
        (widget.config?.hideAuthor ?? true) &&
        (widget.config?.hideComment ?? true)) {
      offset -= 11.0;
    }
    offset *= 3.0 + 1;
    var minHeight = isDesktop
        ? screenSize.height * 2 / 3 + offset
        : isTablet
            ? 350 + offset
            : 250 + offset;
    // var minHeight = getValueForScreenType<double>(
    //   context: context,
    //   mobile: 250 + offset,
    //   tablet: 430 + offset,
    //   desktop: screenSize.height * 2 / 3 + offset,
    // );
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      child: Consumer<ListBlogModel>(builder: (_, model, __) {
        final listBlog = model.blogs?.take(12).toList();
        if (listBlog?.isEmpty ?? true) {
          return Container(
            height: minHeight,
            padding: EdgeInsets.symmetric(
              horizontal: widget.config?.padding ?? 8.0,
            ),
            child: Column(
              children: <Widget>[
                _buildHeader(context, null),
                const Expanded(child: _BlogViewSkeleton()),
                const Expanded(child: _BlogViewSkeleton()),
                const Expanded(child: _BlogViewSkeleton()),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeader(context, listBlog,
                padding: widget.config?.padding ?? 8.0),
            Container(
              color: widget.config?.backgroundColor != null
                  ? HexColor.fromJson(widget.config?.backgroundColor)
                  : Theme.of(context).cardColor,
              child: SingleChildScrollView(
                padding: widget.config?.padding != null
                    ? EdgeInsets.symmetric(
                        horizontal: widget.config?.padding ?? 16.0)
                    : EdgeInsets.only(
                        left: context.isRtl ? 48 : 15,
                        right: context.isRtl ? 15 : 48,
                      ),
                physics: isDesktop
                    ? const BouncingScrollPhysics()
                    : const PageScrollPhysics(),
                controller: pageController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                      List.generate((listBlog!.length / 3).ceil(), (index) {
                    final items = listBlog.skip(index * 3).take(3);
                    return SizedBox(
                      width:
                          isDesktop ? 450 : screenSize.width * viewportFraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: items
                            .map((blog) => BlogGridItem(
                                  config: widget.config as BlogConfig,
                                  blog: blog,
                                  radius: widget.config?.radius ?? 0.0,
                                  background: widget.config?.backgroundColor !=
                                          null
                                      ? HexColor(widget.config?.backgroundColor)
                                      : Colors.transparent,
                                  itemBackgroundColor: widget
                                              .config?.itemBackgroundColor !=
                                          null
                                      ? HexColor(
                                          widget.config?.itemBackgroundColor)
                                      : Colors.transparent,
                                  innerPadding:
                                      widget.config?.innerPadding ?? 0.0,
                                  onTap: () => FluxNavigate.pushNamed(
                                    RouteList.detailBlog,
                                    arguments: BlogDetailArguments(
                                      blog: blog,
                                      listBlog: listBlog.toList(),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _BlogViewSkeleton extends StatelessWidget {
  const _BlogViewSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Flexible(
            flex: 4,
            child: Skeleton(),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(
                  width: 200,
                  height: 20,
                ),
                SizedBox(height: 8),
                Skeleton(
                  width: 100,
                  height: 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
