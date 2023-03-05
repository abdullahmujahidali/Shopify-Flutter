import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../../models/index.dart';
import '../../../../../modules/dynamic_layout/config/blog_config.dart';
import '../../../../../services/index.dart';
import 'pinterest_card.dart';

class PinterestLayout extends StatefulWidget {
  final BlogConfig config;

  const PinterestLayout({required this.config});

  @override
  State<PinterestLayout> createState() => _PinterestLayoutState();
}

class _PinterestLayoutState extends State<PinterestLayout> {
  final Services _service = Services();
  List<Blog> _blogs = [];
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() async {
    var config = widget.config.toJson();
    _page = _page + 1;
    config['page'] = _page;
    var newBlogs = await _service.api.fetchBlogLayout(config: config);
    if (newBlogs != null) {
      setState(() {
        _blogs = [..._blogs, ...newBlogs];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        childCount: _blogs.length,
        itemBuilder: (context, index) => PinterestCard(
          item: _blogs[index],
          listBlog: _blogs,
          showOnlyImage: widget.config.showOnlyImage,
          width: MediaQuery.of(context).size.width / 2,
          showCart: false,
        ),
      ),
    );
  }
}
