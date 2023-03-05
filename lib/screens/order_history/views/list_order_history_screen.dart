import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../widgets/common/paging_list.dart';
import '../../common/app_bar_mixin.dart';
import '../models/list_order_history_model.dart';
import '../models/order_history_detail_model.dart';
import 'widgets/order_list_item.dart';
import 'widgets/order_list_loading_item.dart';

class ListOrderHistoryScreen extends StatefulWidget {
  @override
  State<ListOrderHistoryScreen> createState() => _ListOrderHistoryScreenState();
}

class _ListOrderHistoryScreenState extends State<ListOrderHistoryScreen>
    with AppBarMixin {
  ListOrderHistoryModel get listOrderViewModel =>
      Provider.of<ListOrderHistoryModel>(context, listen: false);

  var mapOrderHistoryDetailModel = <int, OrderHistoryDetailModel>{};

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false).user ?? User();
    return renderScaffold(
      routeName: RouteList.orders,
      secondAppBar: AppBar(
        title: Text(
          S.of(context).orderHistory,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: PagingList<ListOrderHistoryModel, Order>(
        onRefresh: mapOrderHistoryDetailModel.clear,
        itemBuilder: (_, order, index) {
          if (mapOrderHistoryDetailModel[index] == null) {
            final orderHistoryDetailModel = OrderHistoryDetailModel(
              order: order,
              user: user,
            );
            mapOrderHistoryDetailModel[index] = orderHistoryDetailModel;
          }
          return ChangeNotifierProvider<OrderHistoryDetailModel>.value(
            value: mapOrderHistoryDetailModel[index]!,
            child: OrderListItem(),
          );
        },
        lengthLoadingWidget: 3,
        loadingWidget: const OrderListLoadingItem(),
      ),
    );
  }
}
