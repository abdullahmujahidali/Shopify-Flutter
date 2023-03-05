import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/app_model.dart';
import '../../../models/entities/blog.dart';
import '../../../services/services.dart';
import '../../../widgets/blog/detailed_blog_fullsize_image.dart';
import '../../../widgets/blog/detailed_blog_half_image.dart';
import '../../../widgets/blog/detailed_blog_quarter_image.dart';
import '../../../widgets/blog/detailed_blog_view.dart';
import '../../base_screen.dart';
import '../../common/app_bar_mixin.dart';
import '../models/list_blog_model.dart';

class BlogDetailArguments {
  final Blog? blog;
  final String? id;
  final List<Blog>? listBlog;

  BlogDetailArguments({
    this.blog,
    this.listBlog,
    this.id,
  });
}

class BlogDetailScreen extends StatefulWidget {
  final Blog? blog;
  final String? id;
  final List<Blog>? listBlog;

  const BlogDetailScreen({
    required this.blog,
    this.id,
    this.listBlog,
  });

  @override
  BaseScreen<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends BaseScreen<BlogDetailScreen>
    with AppBarMixin {
  PageController controller = PageController(initialPage: 0);
  Blog blog = const Blog.empty(1);
  var listBlog = <Blog>[];

  var initialPage = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    blog = widget.blog ?? blog;
    listBlog = List<Blog>.from(widget.listBlog ?? []);
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (listBlog.isNotEmpty) {
      initialPage = listBlog.indexWhere((element) => element.id == blog.id);
      controller.jumpToPage(initialPage);
    }

    if (widget.id != null) {
      blog = await Services().api.getBlogById(widget.id);
      setState(() {});
    }

    /// This case handle for the Notion platform
    /// The blog item from List Blog get from Notion does not contain the content
    /// So need get content of the blog in the BlogDetail
    if (blog.content.isEmpty) {
      await Services().api.getBlogContent(blog.id).then((content) {
        if (content != null) {
          blog = blog.copyWith(content: content);
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return renderScaffold(
      routeName: RouteList.detailBlog,
      child: Builder(
        builder: (context) {
          if (listBlog.isEmpty) {
            return _buildDetailScreen(blog);
          }

          return PageView.builder(
            itemCount: listBlog.length,
            controller: controller,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final blogItem = listBlog[index];
              if (blogItem.content.isNotEmpty) {
                return _buildDetailScreen(listBlog[index]);
              }

              /// This case handle for the Notion platform
              /// The blog item from List Blog get from Notion does not contain the content
              /// So need get content of the blog in the BlogDetail
              return FutureBuilder<String?>(
                future: Services().api.getBlogContent(blogItem.id),
                builder: (context, snapshot) {
                  final content = snapshot.data;

                  /// Place holder with Blog empty content
                  if (content == null) {
                    return _buildDetailScreen(listBlog[index]);
                  }

                  /// Update content and rebuild content
                  listBlog[index] = blogItem.copyWith(content: content);
                  return _buildDetailScreen(listBlog[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailScreen(Blog blog) {
    printLog('[video link] ${blog.videoUrl}');
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: showAppBar(RouteList.detailBlog) ? EdgeInsets.zero : null,
      ),
      child: Builder(
        builder: (context) {
          if (blog.videoUrl.isNotEmpty && !blog.videoUrl.contains('youtube')) {
            return OneQuarterImageType(item: blog);
          }

          final blogLayout = Provider.of<AppModel>(context).blogDetailLayout;
          switch (blogLayout) {
            case kBlogLayout.halfSizeImageType:
              return HalfImageType(item: blog);
            case kBlogLayout.fullSizeImageType:
              return FullImageType(item: blog);
            case kBlogLayout.oneQuarterImageType:
              return OneQuarterImageType(item: blog);
            case kBlogLayout.simpleType:
            default:
              return BlogDetail(item: blog);
          }
        },
      ),
    );
  }
}
