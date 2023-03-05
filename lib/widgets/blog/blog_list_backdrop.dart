import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/index.dart' show Blog;
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/blog/views/blog_detail_screen.dart';
import '../backdrop/backdrop_constants.dart';
import 'blog_card_view.dart';

class BlogListBackdrop extends StatefulWidget {
  final List<Blog>? blogs;
  final bool? isFetching;
  final bool? isEnd;
  final String? errMsg;
  final width;
  final padding;
  final String? layout;
  final Function? onRefresh;
  final Function onLoadMore;

  const BlogListBackdrop({
    this.isFetching = false,
    this.isEnd = true,
    this.errMsg,
    this.blogs,
    this.width,
    this.padding = 8.0,
    this.onRefresh,
    required this.onLoadMore,
    this.layout = 'list',
  });

  @override
  State<BlogListBackdrop> createState() => _BlogListBackdropState();
}

class _BlogListBackdropState extends State<BlogListBackdrop> {
  late RefreshController _refreshController;
  int _page = 1;

  List<Blog> emptyList = const [
    Blog.empty(1),
    Blog.empty(2),
    Blog.empty(3),
    Blog.empty(4),
    Blog.empty(5),
    Blog.empty(6)
  ];

  @override
  void initState() {
    super.initState();

    /// if there are existing product from previous navigate we don't need to enable the refresh
    _refreshController = RefreshController(initialRefresh: false);
  }

  void _onRefresh() {
    if (!widget.isFetching!) {
      _page = 1;
      widget.onRefresh!();
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    if (!widget.isFetching! && !widget.isEnd!) {
      _page = _page + 1;
      widget.onLoadMore(_page);
    }
    _refreshController.loadComplete();
  }

  @override
  void didUpdateWidget(BlogListBackdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.blogs != oldWidget.blogs) {
      setState(() {});
    }
    if (widget.isFetching == false && oldWidget.isFetching == true) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = Tools.isTablet(MediaQuery.of(context));

    var widthScreen = widget.width ?? screenSize.width;
    var widthContent = screenSize.width;
    var crossAxisCount = 1;
    var childAspectRatio = 0.8;

    if (Layout.isDisplayDesktop(context)) {
      widthScreen -= BackdropConstants.drawerWidth;
    }
    if (widget.layout == 'card') {
      crossAxisCount = isTablet ? 2 : 1;
      widthContent = isTablet ? widthScreen / 2 : widthScreen; //one column
    } else if (widget.layout == 'columns') {
      crossAxisCount = isTablet ? 4 : 3;
      widthContent =
          isTablet ? widthScreen / 4 : (widthScreen / 3); //three columns
    } else if (widget.layout == 'listTile') {
      crossAxisCount = isTablet ? 2 : 1;
      widthContent = widthScreen - 24; // one column
    } else {
      /// 2 columns on mobile, 3 columns on ipad
      crossAxisCount = isTablet ? 3 : 2;
      //layout is list
      widthContent =
          isTablet ? widthScreen / 3 : (widthScreen / 2); //two columns
    }

    final blogsList =
        (widget.blogs == null || widget.blogs!.isEmpty) && widget.isFetching!
            ? emptyList
            : widget.blogs;

    if (blogsList == null || blogsList.isEmpty) {
      return const SizedBox();
    }

    Widget typeList = const SizedBox();

    switch (widget.layout) {
      case Layout.listTile:
        typeList = buildListView(
          blogs: blogsList,
          widthContent: widthContent,
        );
        break;
      case Layout.pinterest:
        typeList = buildStaggeredGridView(
          blogs: blogsList,
          widthContent: widthScreen,
        );
        break;
      case Layout.card:
      case Layout.columns:
      default:
        typeList = buildGridView(
          childAspectRatio: childAspectRatio,
          crossAxisCount: crossAxisCount,
          blogsList: blogsList,
          widthContent: widthContent,
        );
    }

    return SmartRefresher(
      header: MaterialClassicHeader(
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      footer: kCustomFooter(context),
      child: typeList,
    );
  }

  Widget buildGridView({
    required int crossAxisCount,
    required double childAspectRatio,
    double? widthContent,
    required List<Blog> blogsList,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: widget.layout == 'card' ? 1.5 : childAspectRatio,
      ),
      cacheExtent: 500.0,
      itemCount: blogsList.length,
      itemBuilder: (context, i) {
        return BlogCard(
          item: blogsList[i],
          width: widthContent,
          margin: widget.layout == 'card' ? 12.0 : 8.0,
          onTap: () {
            FluxNavigate.pushNamed(
              RouteList.detailBlog,
              arguments: BlogDetailArguments(
                blog: blogsList[i],
                listBlog: blogsList,
              ),
            );
          },
        );
      },
    );
  }

  Widget buildListView({
    required List<Blog> blogs,
    double? widthContent,
  }) {
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (_, index) => BlogCard(
          item: blogs[index],
          width: widthContent,
          onTap: () {
            FluxNavigate.pushNamed(
              RouteList.detailBlog,
              arguments: BlogDetailArguments(
                blog: blogs[index],
                listBlog: blogs,
              ),
            );
          }),
    );
  }

  Widget buildStaggeredGridView({
    required List<Blog> blogs,
    double? widthContent,
  }) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 8.0,
      padding: const EdgeInsets.only(
        bottom: 32,
        left: 8,
        right: 8,
      ),
      itemCount: blogs.length,
      itemBuilder: (context, index) => BlogCard(
          item: blogs[index],
          width: MediaQuery.of(context).size.width / 2,
          onTap: () {
            FluxNavigate.pushNamed(
              RouteList.detailBlog,
              arguments: BlogDetailArguments(
                blog: blogs[index],
                listBlog: blogs,
              ),
            );
          }),
      // staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
    );
  }
}
