import 'package:flutter/material.dart';
import 'package:inspireui/widgets/skeleton_widget/skeleton_widget.dart';

import '../../../models/category/list_product_model.dart';
import '../../../models/entities/product.dart';
import '../../../widgets/common/paging_list.dart';
import '../../../widgets/product/product_simple_view.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({Key? key}) : super(key: key);

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct>
    with AutomaticKeepAliveClientMixin<ListProduct> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PagingList<ListProductModel, Product>(
      itemBuilder: (context, item, index) {
        return ProductSimpleView(
          item: item,
          isFromSearchScreen: true,
        );
      },
      loadingWidget: const _ProductSimpleViewSkeleton(),
      lengthLoadingWidget: 8,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ProductSimpleViewSkeleton extends StatelessWidget {
  const _ProductSimpleViewSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Skeleton(
            width: 60,
            height: 60,
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Skeleton(width: 200, height: 14),
                SizedBox(height: 6),
                Skeleton(width: 90, height: 14),
                SizedBox(height: 12),
                Skeleton(width: 40, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
