import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show Skeleton;
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/paging_list.dart';
import '../../base_screen.dart';
import '../../common/app_bar_mixin.dart';
import '../models/list_blog_model.dart';
import 'blog_detail_screen.dart';
import 'widgets/blog_list_item.dart';

class ListBlogScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListBlogScreenState();
}

class _ListBlogScreenState extends BaseScreen<ListBlogScreen> with AppBarMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    screenScrollController = _scrollController;
  }

  @override
  Widget build(BuildContext context) {
    return renderScaffold(
      routeName: RouteList.listBlog,
      secondAppBar: AppBar(
          elevation: 0.1,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            S.of(context).blog,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          leading: !(ModalRoute.of(context)?.canPop ?? false)
              ? null
              : Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                )),
      child: PagingList<ListBlogModel, Blog>(
        scrollController: _scrollController,
        itemBuilder: (context, blog, _) => BlogListItem(
          blog: blog,
          onTap: () {
            FluxNavigate.pushNamed(
              RouteList.detailBlog,
              arguments: BlogDetailArguments(
                blog: blog,
                listBlog:
                    Provider.of<ListBlogModel>(context, listen: false).data,
              ),
            );
          },
        ),
        loadingWidget: _buildSkeleton(),
        lengthLoadingWidget: 3,
        autoInitData: false,
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 24.0,
        top: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Skeleton(height: 200),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Skeleton(width: 120),
              Skeleton(width: 80),
            ],
          ),
          const SizedBox(height: 16),
          const Skeleton(),
        ],
      ),
    );
  }
}
