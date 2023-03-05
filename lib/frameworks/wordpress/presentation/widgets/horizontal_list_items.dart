import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../common/tools.dart';
import '../../../../models/index.dart';
import '../../../../modules/dynamic_layout/helper/header_view.dart';
import '../../../../modules/dynamic_layout/helper/helper.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../screens/index.dart';
import '../../../../services/index.dart';
import '../../../../widgets/blog/blog_heart_button.dart';
import '../../../../widgets/common/index.dart' show FluxImage;

class LargeCardHorizontalListItems extends StatefulWidget {
  final Map<String, dynamic>? config;

  const LargeCardHorizontalListItems(this.config, {Key? key}) : super(key: key);

  @override
  State<LargeCardHorizontalListItems> createState() =>
      _LargeCardHorizontalListItemsState();
}

class _LargeCardHorizontalListItemsState
    extends State<LargeCardHorizontalListItems> {
  final Services _service = Services();

  late Future<List<Blog>?> _getBlogsLayout;

  final _memoizer = AsyncMemoizer<List<Blog>?>();

  final blogEmptyList = const [Blog.empty(1), Blog.empty(2), Blog.empty(3)];

  bool get isDesktopDisplay => Layout.isDisplayDesktop(context);

  @override
  void initState() {
    /// only create the future once
    _getBlogsLayout = getBlogLayout(context);
    super.initState();
  }

  Future<List<Blog>?> getBlogLayout(context) async {
    return _memoizer.runOnce(() {
      return _service.api.fetchBlogLayout(
          config: widget.config,
          lang: Provider.of<AppModel>(context, listen: false).langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRecent = widget.config!['layout'] == 'recentView' ? true : false;
    final imageBorder =
        Tools.formatDouble(widget.config!['imageBorder'] ?? 3.0);
    final imagePercent = isDesktopDisplay ? 1 / 3 : 1 / 2;
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Blog>?>(
        future: _getBlogsLayout,
        builder: (BuildContext context, AsyncSnapshot<List<Blog>?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Column(
                    children: <Widget>[
                      HeaderView(
                        headerText: widget.config!['name'] ?? ' ',
                        showSeeAll: isRecent ? false : true,
                        callback: () => FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            config: widget.config,
                            data: snapshot.data,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < 3; i++)
                              _LargeBlogCard(
                                blogs: blogEmptyList,
                                index: i,
                                width: Tools.formatDouble(
                                    widget.config!['imageWidth'] ??
                                        constraints.maxWidth * imagePercent),
                                imageBorder: imageBorder,
                                onTap: () {},
                              ),
                          ],
                        ),
                      ),
                    ],
                  ));
            case ConnectionState.done:
            default:
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    HeaderView(
                      headerText: widget.config?['name'] ?? ' ',
                      showSeeAll: isRecent ? false : true,
                      callback: () => FluxNavigate.pushNamed(
                        RouteList.backdrop,
                        arguments: BackDropArguments(
                          config: widget.config,
                          data: snapshot.data,
                        ),
                      ),
                    ),
                    snapshot.hasError
                        ? const SizedBox(height: 200)
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                snapshot.data?.length ?? 0,
                                (index) {
                                  return _LargeBlogCard(
                                    blogs: snapshot.data ?? [],
                                    index: index,
                                    width: Tools.formatDouble(widget
                                            .config!['imageWidth'] ??
                                        constraints.maxWidth * imagePercent),
                                    imageBorder: imageBorder,
                                    context: context,
                                    onTap: () {
                                      FluxNavigate.pushNamed(
                                        RouteList.detailBlog,
                                        arguments: BlogDetailArguments(
                                          blog: snapshot.data![index],
                                          listBlog: snapshot.data ?? [],
                                        ),
                                      );
                                    },
                                    //isHero: true,
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              );
          }
        },
      );
    });
  }
}

class _LargeBlogCard extends StatelessWidget {
  final List<Blog> blogs;
  final int index;
  final double? width;
  final double? imageBorder;
  final context;
  final onTap;

  const _LargeBlogCard({
    required this.blogs,
    required this.index,
    required this.width,
    required this.imageBorder,
    this.context,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var imageWidth = width;
    var titleFontSize = imageWidth! / 10;

    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'blog-${blogs[index].id}',
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(imageBorder!),
                ),
                child: FluxImage(
                  imageUrl: blogs[index].imageFeature,
                  width: imageWidth,
                  height: imageWidth * 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: imageWidth,
              height: imageWidth * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(imageBorder!)),
                gradient: const LinearGradient(
                    colors: [Colors.black54, Colors.black26, Colors.black12],
                    stops: [0.4, 0.7, 0.9],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center),
              ),
            ),
            Positioned(
              bottom: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: imageWidth - 30,
                  height: imageWidth * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        blogs[index].title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: imageWidth / 35,
                      ),
                      Text(
                        blogs[index].date == ''
                            ? 'Loading ...'
                            : blogs[index].date,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: titleFontSize - 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            kBlogDetail['showHeart']
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: BlogHeartButton(
                      blog: blogs[index],
                      size: 23,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
