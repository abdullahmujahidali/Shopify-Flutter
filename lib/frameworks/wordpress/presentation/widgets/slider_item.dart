import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../common/tools/tools.dart';
import '../../../../models/app_model.dart';
import '../../../../models/entities/index.dart';
import '../../../../modules/dynamic_layout/helper/header_view.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../screens/index.dart';
import '../../../../services/services.dart';
import '../../../../widgets/blog/blog_heart_button.dart';
import '../../../../widgets/common/index.dart' show FluxImage;

class SliderItem extends StatefulWidget {
  final Map<String, dynamic>? config;

  const SliderItem(this.config, {Key? key}) : super(key: key);

  @override
  State<SliderItem> createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItem> {
  final Services _service = Services();
  final _listBlogNotifier = ValueNotifier<List<Blog>?>(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        final data = await _service.api.fetchBlogLayout(
          config: widget.config,
          lang: Provider.of<AppModel>(context, listen: false).langCode,
        );
        _listBlogNotifier.value = data ?? [];
      }
    });
  }

  @override
  void dispose() {
    _listBlogNotifier.dispose();
    super.dispose();
  }

  final blogEmptyList = const [Blog.empty(1), Blog.empty(2), Blog.empty(3)];

  @override
  Widget build(BuildContext context) {
    final isRecent = widget.config!['layout'] == 'recentView' ? true : false;

    final imageBorder =
        Tools.formatDouble(widget.config!['imageBorder'] ?? 3.0);

    return ValueListenableBuilder<List<Blog>?>(
      valueListenable: _listBlogNotifier,
      builder: (context, value, child) {
        if (value == null) {
          return Column(
            children: <Widget>[
              HeaderView(
                headerText: widget.config!['name'] ?? ' ',
                showSeeAll: isRecent ? false : true,
                callback: () => FluxNavigate.pushNamed(
                  RouteList.backdrop,
                  arguments: BackDropArguments(
                    config: widget.config,
                    data: null,
                  ),
                ),
              ),
              const _SliderItemSkeleton(),
            ],
          );
        }

        return Column(
          children: <Widget>[
            HeaderView(
              headerText: widget.config!['name'] ?? ' ',
              showSeeAll: isRecent ? false : true,
              callback: () => FluxNavigate.pushNamed(
                RouteList.backdrop,
                arguments: BackDropArguments(
                  config: widget.config,
                  data: null,
                ),
              ),
            ),
            value.isEmpty
                ? const SizedBox(height: 200)
                : Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 350,
                    child: PageView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return _BlogItem(
                          blogs: value,
                          index: index,
                          imageBorder: imageBorder,
                          context: context,
                          onTap: () {
                            FluxNavigate.pushNamed(
                              RouteList.detailBlog,
                              arguments: BlogDetailArguments(
                                blog: value[index],
                                listBlog: value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _BlogItem extends StatelessWidget {
  final List<Blog> blogs;
  final index;
  final double? imageBorder;
  final context;
  final onTap;

  const _BlogItem({
    required this.blogs,
    this.index,
    this.imageBorder,
    this.context,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var imageWidth = 150;
    var titleFontSize = imageWidth / 10;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 6, right: 6),
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(imageBorder!),
                  ),
                  child: FluxImage(
                    imageUrl: blogs[index].imageFeature,
                    width: screenWidth,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                kBlogDetail['showHeart']
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: BlogHeartButton(
                          blog: blogs[index],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    blogs[index].title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    blogs[index].date == '' ? 'Loading ...' : blogs[index].date,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  blogs[index].excerpt == 'Loading...'
                      ? Text(blogs[index].excerpt)
                      : Text(
                          parse(blogs[index].excerpt).documentElement?.text ??
                              '',
                          maxLines: 3,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 13.0,
                                  height: 1.4,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SliderItemSkeleton extends StatelessWidget {
  const _SliderItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Skeleton(
            height: 205,
            width: 500,
          ),
          SizedBox(height: 8),
          Skeleton(
            height: 15,
            width: 250,
          ),
          SizedBox(height: 4),
          Skeleton(
            height: 12,
            width: 100,
          ),
          SizedBox(height: 12),
          Skeleton(
            height: 12,
            width: 400,
          ),
          SizedBox(height: 4),
          Skeleton(
            height: 12,
            width: 400,
          ),
          SizedBox(height: 4),
          Skeleton(
            height: 12,
            width: 200,
          ),
        ],
      ),
    );
  }
}
