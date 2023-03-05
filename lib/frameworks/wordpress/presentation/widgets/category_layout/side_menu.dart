import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/config.dart';
import '../../../../../common/constants.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../models/index.dart';
import '../../../../../routes/flux_navigate.dart';
import '../../../../../screens/index.dart';
import '../../../../../services/index.dart';
import '../../../../../widgets/blog/blog_card_view.dart';

class SideMenuCategories extends StatefulWidget {
  static const String type = 'sideMenu';

  const SideMenuCategories();

  @override
  State<StatefulWidget> createState() {
    return SideMenuCategoriesState();
  }
}

class SideMenuCategoriesState extends State<SideMenuCategories> {
  int selectedIndex = 0;
  final Services _service = Services();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<CategoryModel>(
      builder: (context, value, child) {
        if (value.isFirstLoad) {
          return kLoadingWidget(context);
        }
        var categories = value.categories
                ?.where((item) => item.parent.toString() == '0')
                .toList() ??
            [];
        if (categories.isEmpty) {
          return Center(
            child: Text(S.of(context).noData),
          );
        }

        return Row(
          children: <Widget>[
            Container(
              width: 100,
              color: Theme.of(context).primaryColorLight,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 4, right: 4),
                      child: Center(
                        child: Text(
                          categories[index].displayName,
                          style: TextStyle(
                            fontSize: 10,
                            color: selectedIndex == index
                                ? theme.primaryColor
                                : theme.colorScheme.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(child: LayoutBuilder(
              builder: (context, constraints) {
                return FutureBuilder<List<Blog>>(
                  future: _service.api.fetchBlogsByCategory(
                    lang:
                        Provider.of<AppModel>(context, listen: false).langCode,
                    categoryId: categories[selectedIndex].id,
                    page: 1,
                  ),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Blog>> snapshot) {
                    if (!snapshot.hasData) {
                      return kLoadingWidget(context);
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) => BlogCard(
                        item: snapshot.data![index],
                        width: constraints.maxWidth,
                        onTap: () => FluxNavigate.pushNamed(
                          RouteList.detailBlog,
                          arguments: BlogDetailArguments(
                            blog: snapshot.data![index],
                            listBlog: snapshot.data,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ))
          ],
        );
      },
    );
  }
}
