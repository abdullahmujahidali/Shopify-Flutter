import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../models/index.dart';
import '../../../../../services/index.dart';
import '../../../../../widgets/blog/blog_card_view.dart';
import 'blog_select_card.dart';

class MenuLayout extends StatefulWidget {
  const MenuLayout();

  @override
  State<MenuLayout> createState() => _StateSelectLayout();
}

class _StateSelectLayout extends State<MenuLayout> {
  int position = 0;
  bool loading = false;
  List<List<Blog>> blogs = [];
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getAllListBlogs({lang, page = 1, categories}) async {
    if (this.blogs.isNotEmpty) return true;
    var blogs = <List<Blog>>[];
    var service = Services();
    for (var category in categories) {
      var blog = await service.api.fetchBlogsByCategory(
          categoryId: category.id, lang: lang, page: page);
      blogs.add(blog);
      setState(() {
        this.blogs = blogs;
      });
    }
    return true;
  }

  List<Category> getAllCategory() {
    final categories =
        Provider.of<CategoryModel>(context, listen: true).categories ?? [];
    var listCategories =
        categories.where((item) => item.isRoot).toList();
    var result = <Category>[];
    for (var category in listCategories) {
      var children = categories.where((o) => o.parent == category.id).toList();
      if (children.isNotEmpty) {
        result = [...result, ...children];
      } else {
        result = [...result, category];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var categories = getAllCategory();
    if (categories.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        height: 70,
        padding: const EdgeInsets.only(top: 15),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(categories.length, (index) {
            var check = (blogs.length > index)
                ? (blogs[index].isEmpty ? false : true)
                : true;
            return GestureDetector(
              onTap: () {
                setState(() {
                  position = index;
                });
              },
              child: !check
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              categories[index].name!.toUpperCase(),
                              style: TextStyle(
                                  color: index == position
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          index == position
                              ? Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).primaryColor),
                                  width: 20,
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
            );
          }),
        ),
      ),
      FutureBuilder<bool>(
        future: getAllListBlogs(categories: categories),
        builder: (context, check) {
          if (blogs.isEmpty) {
            return MasonryGridView.count(
              crossAxisCount: 4,
              key: Key(categories[position].id.toString()),
              shrinkWrap: true,
              controller: _controller,
              itemCount: 4,
              itemBuilder: (context, value) {
                return BlogCard(
                  item: Blog.empty(value),
                  width: MediaQuery.of(context).size.width / 2,
                  onTap: () {},
                );
              },
              // staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
            );
          }
          if (blogs[position].isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Text(S.of(context).noProduct),
              ),
            );
          }
          return MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: MasonryGridView.count(
              crossAxisCount: 2,
              key: Key(categories[position].id.toString()),
              shrinkWrap: true,
              controller: _controller,
              itemCount: blogs[position].length,
              itemBuilder: (context, value) {
                return BlogSelectCard(
                  item: blogs[position][value],
                  listBlog: blogs[position],
                  width: MediaQuery.of(context).size.width / 2,
                );
              },
              // staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
            ),
          );
        },
      ),
    ]));
  }
}
