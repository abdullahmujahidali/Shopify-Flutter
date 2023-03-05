import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../../../../../common/tools.dart';
import '../../../../../routes/flux_navigate.dart';
import '../../../../../screens/blog/index.dart';

enum SimpleListType { backgroundColor, priceOnTheRight }

class SimpleListView extends StatelessWidget {
  final Blog item;
  final List<Blog> listBlog;
  final SimpleListType type;

  const SimpleListView({
    required this.item,
    required this.type,
    required this.listBlog,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var titleFontSize = 15.0;
    var imageWidth = 60;
    var imageHeight = 60;
    void onTapProduct() {
      if (item.imageFeature == '') return;
      FluxNavigate.pushNamed(
        RouteList.detailBlog,
        arguments: BlogDetailArguments(
          blog: item,
          listBlog: listBlog,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: onTapProduct,
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: type == SimpleListType.backgroundColor
                ? Theme.of(context).primaryColorLight
                : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: ImageResize(
                        url: item.imageFeature,
                        width: imageWidth.toDouble(),
                        size: kSize.medium,
                        height: imageHeight.toDouble(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        item.date,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
