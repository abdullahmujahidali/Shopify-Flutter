import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/blog_search_model.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../screens/blog/views/blog_detail_screen.dart';
import '../../../../widgets/blog/blog_card_view.dart';

class RecentlyViewedBlogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenWidth = constraints.maxWidth;

        return ListenableProvider.value(
          value: Provider.of<BlogSearchModel>(context, listen: false),
          child: Consumer<BlogSearchModel>(builder: (context, model, child) {
            if (model.blogs.isEmpty) {
              return const SizedBox();
            }
            return Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(S.of(context).recentSearches,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ),
//                FlatButton(
//                    onPressed: null,
//                    child: Text(
//                      S.of(context).seeAll,
//                      style: TextStyle(color: Colors.greenAccent, fontSize: 13),
//                    ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  height: 1,
                  color: kGrey200,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenWidth * 0.35 + 120,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 8),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var item in model.blogs)
                          BlogCard(
                            item: item,
                            width: screenWidth * 0.35,
                            onTap: () => FluxNavigate.pushNamed(
                              RouteList.detailBlog,
                              arguments: BlogDetailArguments(
                                blog: item,
                                listBlog: model.blogs,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
