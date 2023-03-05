import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/constants.dart';
import '../../../../models/entities/blog.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../screens/blog/views/blog_detail_screen.dart';
import '../../../../services/services.dart';
import '../../../../widgets/blog/blog_card_view.dart';

class BlogList extends StatefulWidget {
  final name;
  final padding;
  final blogs;

  const BlogList({this.blogs, this.name, this.padding = 10.0});

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  late RefreshController _refreshController;

  List<Blog> _blogs = [];
  int _page = 1;

  @override
  // ignore: always_declare_return_types
  initState() {
    super.initState();
    _blogs = widget.blogs ?? [];
    _refreshController = RefreshController(initialRefresh: _blogs.isEmpty);
  }

  @override
  void didUpdateWidget(covariant BlogList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_blogs != widget.blogs) {
      setState(() {
        _blogs = widget.blogs;
      });
    }
  }

  void _loadProduct() async {
    var newBlogs = await Services().api.searchBlog(name: widget.name);
    _blogs = [..._blogs, ...newBlogs];
  }

  void _onRefresh() async {
    _page = 1;
    _blogs = [];
    _loadProduct();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page = _page + 1;
    _loadProduct();
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widthContent = (constraints.maxWidth - 48) / 2;

        return SmartRefresher(
          header: MaterialClassicHeader(
              backgroundColor: Theme.of(context).primaryColor),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: _blogs.isEmpty
              ? const SizedBox()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    runSpacing: 8,
                    children: <Widget>[
                      for (var i = 0; i < _blogs.length; i++)
                        BlogCard(
                          item: _blogs[i],
                          width: widthContent,
                          onTap: () => FluxNavigate.pushNamed(
                            RouteList.detailBlog,
                            arguments: BlogDetailArguments(
                              blog: _blogs[i],
                              listBlog: _blogs,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
