import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/blog_search_model.dart';
import 'recently_viewed_blogs.dart';

class BlogRecentSearch extends StatelessWidget {
  final Function onTap;

  const BlogRecentSearch({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widthContent = (screenSize.width / 2) - 4;

    return ListenableProvider.value(
      value: Provider.of<BlogSearchModel>(context, listen: false),
      child: Consumer<BlogSearchModel>(builder: (context, model, child) {
        return Column(
          children: <Widget>[
            model.keywords.isEmpty
                ? renderEmpty(context)
                : renderKeywords(model, widthContent, context)
          ],
        );
      }),
    );
  }

  Widget renderEmpty(context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/empty_search.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: 250,
              child: Text(
                S.of(context).emptySearch,
                style: const TextStyle(color: kGrey400),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }

  Widget renderKeywords(
      BlogSearchModel model, double widthContent, BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(S.of(context).recentSearches),
                      if (model.keywords.isNotEmpty)
                        InkWell(
                            onTap: () {
                              Provider.of<BlogSearchModel>(context,
                                      listen: false)
                                  .clearKeywords();
                            },
                            child: Text(S.of(context).clear,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 13)))
                    ],
                  ),
                ),
                Card(
                  color: Theme.of(context).primaryColorLight,
                  child: Column(
                    children: List.generate(
                        (model.keywords.length < 5) ? model.keywords.length : 5,
                        (index) {
                      return ListTile(
                          title: Text(model.keywords[index]),
                          onTap: () {
                            onTap(model.keywords[index]);
                          });
                    }),
                  ),
                ),
              ],
            ),
          ),
          RecentlyViewedBlogs(),
        ],
      ),
    );
  }
}
