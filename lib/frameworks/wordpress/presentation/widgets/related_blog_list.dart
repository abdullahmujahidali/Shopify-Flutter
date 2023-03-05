import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../screens/blog/index.dart';
import '../../../../services/services.dart';
import '../../../../widgets/common/index.dart' show FluxImage;

class RelatedBlogList extends StatefulWidget {
  final categoryId;
  final kBlogLayout type;

  const RelatedBlogList({required this.categoryId, required this.type});

  @override
  State<RelatedBlogList> createState() => _RelatedBlogListState();
}

class _RelatedBlogListState extends State<RelatedBlogList> {
  final Services _service = Services();
  final _listBlogNotifier = ValueNotifier<List<Blog>?>(null);
  final blogEmptyList = const [Blog.empty(1), Blog.empty(2), Blog.empty(3)];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        final data = await _service.api.getBlogsByCategory(widget.categoryId);
        _listBlogNotifier.value = data ?? [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Blog>?>(
      valueListenable: _listBlogNotifier,
      builder: (context, value, child) {
        if (value == null) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 5, bottom: 10, top: 5),
                  child: Text(
                    S.of(context).relatedLayoutTitle,
                    textAlign: TextAlign.left,
                    style: widget.type == kBlogLayout.fullSizeImageType
                        ? Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                        : Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (var i = 0; i < 3; i++)
                          _BlogItem(
                            blogs: blogEmptyList,
                            index: i,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (value.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              child: Text(
                S.of(context).relatedLayoutTitle,
                textAlign: TextAlign.left,
                style: widget.type == kBlogLayout.fullSizeImageType
                    ? Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                    : Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(value.length, (index) {
                    return _BlogItem(
                      blogs: value,
                      index: index,
                      context: context,
                      type: widget.type,
                    );
                  }),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _BlogItem extends StatelessWidget {
  final List<Blog>? blogs;
  final index;
  final context;
  final kBlogLayout? type;

  const _BlogItem({this.blogs, this.index, this.context, this.type});

  @override
  Widget build(BuildContext context) {
    var imageWidth = 70;
    var titleFontSize = imageWidth / 6;

    return GestureDetector(
      onTap: () {
        FluxNavigate.pushNamed(
          RouteList.detailBlog,
          arguments: BlogDetailArguments(
            blog: blogs![index],
            listBlog: blogs!,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(7.0),
                  ),
                  child: FluxImage(
                    imageUrl: blogs![index].imageFeature,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                // kBlogDetail['showHeart']
                //     ? Positioned(
                //         top: 0,
                //         right: 0,
                //         child: HeartButton(
                //           blog: blogs[index],
                //           size: 15,
                //         ),
                //       )
                //     : const SizedBox(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  blogs![index].title,
                  style: type == kBlogLayout.fullSizeImageType
                      ? TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)
                      : TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  blogs![index!].date,
                  style: type == kBlogLayout.fullSizeImageType
                      ? TextStyle(fontSize: titleFontSize, color: Colors.white)
                      : TextStyle(
                          fontSize: titleFontSize,
                          color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
