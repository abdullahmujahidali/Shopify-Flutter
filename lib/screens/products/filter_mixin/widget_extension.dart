part of 'products_filter_mixin.dart';

extension ProductsFilterMixinWidgetExtension on ProductsFilterMixin {
  Widget renderFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _renderFilterTitle(context),
        ),
        const SizedBox(width: 5),
        const SizedBox(
          height: 44,
          child: VerticalDivider(
            width: 15,
            indent: 8,
            endIndent: 8,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 5),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Text(S.of(context).filter,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 4),
              const Icon(CupertinoIcons.chevron_down, size: 13),
            ],
          ),
          onPressed: () => showModalBottomSheet(
            context: App.fluxStoreNavigatorKey.currentContext!,
            isScrollControlled: true,
            isDismissible: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Stack(
              children: [
                GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Container(color: Colors.transparent),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.2,
                  maxChildSize: 0.9,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: Stack(
                            children: [
                              const DragHandler(),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: BackdropMenu(
                                  onFilter: onFilter,
                                  categoryId: categoryId,
                                  sortBy: filterSortBy,
                                  tagId: tagId,
                                  listingLocationId: listingLocationId,
                                  controller: scrollController,
                                  minPrice: minPrice,
                                  maxPrice: maxPrice,

                                  /// hide layout filter from Search screen
                                  showLayout: shouldShowLayout,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _renderFilterTitle(BuildContext context) {
    var attributeTerms = getAttributeTerm(showName: true);
    var attributeList =
        attributeTerms.isNotEmpty ? attributeTerms.split(',') : [];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _renderFilterSortByTag(context),
          const SizedBox(width: 5),
          if (attributeList.isNotEmpty)
            for (int i = 0; i < attributeList.length; i++)
              FilterLabel(
                label: attributeList[i].toString(),
                onTap: () {
                  resetFilter();
                  onFilter();
                },
              ),
          if (tagName.isNotEmpty)
            FilterLabel(
              label: tagName.capitalize(),
              onTap: () {
                resetTag();
                onFilter(tagId: '');
              },
            ),
          if (minPrice != null && maxPrice != null && maxPrice != 0)
            FilterLabel(
              onTap: () {
                resetPrice();
                onFilter(minPrice: 0.0, maxPrice: 0.0);
              },
              label:
                  '${minPrice?.toStringAsFixed(0) ?? ''} - ${maxPrice?.toStringAsFixed(0) ?? ''}',
            ),
        ],
      ),
    );
  }

  Widget _renderFilterSortByTag(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (filterSortBy.displaySpecial != null)
          FilterLabel(
            label: filterSortBy.displaySpecial!,
            onTap: () {
              filterSortBy = filterSortBy.applyOnSale(null).applyFeatured(null);
              onFilter();
            },
            leading: filterSortBy.onSale ?? false
                ? Icon(
                    CupertinoIcons.tag_solid,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    CupertinoIcons.star_circle_fill,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
        if (filterSortBy.displayOrderBy != null)
          FilterLabel(
            label: filterSortBy.displayOrderBy!,
            icon: filterSortBy.orderType == null
                ? null
                : (filterSortBy.orderType!.isAsc
                    ? Icon(
                        CupertinoIcons.sort_up,
                        size: 20,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6),
                      )
                    : Icon(
                        CupertinoIcons.sort_down,
                        size: 20,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6),
                      )),
            onTap: () {
              filterSortBy = filterSortBy.applyOrder(null).applyOrderBy(null);
              onFilter();
            },
          ),
      ],
    );
  }
}
