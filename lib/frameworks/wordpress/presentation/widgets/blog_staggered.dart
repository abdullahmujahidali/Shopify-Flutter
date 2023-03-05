import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../screens/blog/index.dart';
import '../../../../widgets/blog/blog_heart_button.dart';
import '../../../../widgets/common/index.dart' show FluxImage;

List<StaggeredGridTile> _staggeredTiles = const <StaggeredGridTile>[
  StaggeredGridTile.count(
    crossAxisCellCount: 2,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 3,
    mainAxisCellCount: 2,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
];

class BlogStaggered extends StatefulWidget {
  final List<Blog> blogs;

  const BlogStaggered(this.blogs);

  @override
  State<BlogStaggered> createState() => _StateProductStaggered();
}

class _StateProductStaggered extends State<BlogStaggered> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.only(left: 15.0),
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            children: [
              for (var i = 0; i < widget.blogs.length; i++)
                StaggeredGridTile.count(
                  crossAxisCellCount: _staggeredTiles[i % 6].crossAxisCellCount,
                  mainAxisCellCount: _staggeredTiles[i % 6].mainAxisCellCount!,
                  child: StaggeredBlogCard(
                    width: (constraints.maxWidth / 3) *
                        _staggeredTiles[i % 6].mainAxisCellCount!.toDouble(),
                    height: (constraints.maxWidth / 3) *
                            _staggeredTiles[i % 6].crossAxisCellCount -
                        20,
                    blogs: widget.blogs,
                    index: i,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class StaggeredBlogCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double? marginRight;
  final bool isHero;
  final List<Blog> blogs;
  final int index;

  const StaggeredBlogCard({
    required this.blogs,
    required this.index,
    this.width,
    this.isHero = false,
    this.height,
    this.marginRight = 10.0,
  });

  Widget getImageFeature(onTapProduct) {
    return GestureDetector(
      onTap: onTapProduct,
      child: isHero
          ? Hero(
              tag: 'blog-${blogs[index].id}',
              child: FluxImage(
                imageUrl: blogs[index].imageFeature,
                width: width,
                height: height ?? width! * 1.2,
                fit: BoxFit.cover,
              ),
            )
          : FluxImage(
              imageUrl: blogs[index].imageFeature,
              width: width,
              height: height ?? width! * 1.2,
              fit: BoxFit.cover,
            ),
    );
  }

  void onTapProduct() {
    if (blogs[index].imageFeature == '') return;
    FluxNavigate.pushNamed(
      RouteList.detailBlog,
      arguments: BlogDetailArguments(
        blog: blogs[index],
        listBlog: blogs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.only(right: 2),
          child: getImageFeature(onTapProduct),
        ),
        if (kBlogDetail['showHeart'] && !blogs[index].isEmpty)
          Positioned(
            top: 0,
            right: 0,
            child: BlogHeartButton(
              blog: blogs[index],
              size: 18,
            ),
          )
      ],
    );
  }
}
