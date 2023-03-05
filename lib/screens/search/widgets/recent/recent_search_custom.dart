import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/search_model.dart';
import 'recent_products_custom.dart';

class RecentSearchesCustom extends StatelessWidget {
  final Function? onTap;

  const RecentSearchesCustom({this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widthContent = (screenSize.width / 2) - 4;

    return Consumer<SearchModel>(
      builder: (context, model, child) {
        return (model.keywords.isEmpty)
            ? renderEmpty(context)
            : renderKeywords(model, widthContent, context);
      },
    );
  }

  Widget renderEmpty(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          kEmptySearch,
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
          ),
        )
      ],
    );
  }

  Widget renderKeywords(
      SearchModel model, double widthContent, BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                S.of(context).recentSearches,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (model.keywords.isNotEmpty)
                InkWell(
                  onTap: model.clearKeywords,
                  child: Text(
                    S.of(context).clear,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                    ),
                  ),
                )
            ],
          ),
        ),
        Card(
          elevation: 0,
          color: Theme.of(context).primaryColorLight,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: model.keywords
                .take(5)
                .map((e) => ListTile(
                      title: Text(e),
                      onTap: () {
                        onTap?.call(e);
                      },
                    ))
                .toList(),
          ),
        ),
        RecentProductsCustom(),
      ],
    );
  }
}
