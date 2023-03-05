import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../models/entities/index.dart';
import '../../models/order/order.dart';
import 'widgets/re_order_item_list.dart';

class ReOrderIndex extends StatelessWidget {
  final Order order;

  const ReOrderIndex({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: TextButton(
        onPressed: () => _reOrder(context),
        child: Text(
          S.of(context).reOrder,
        ),
      ),
    );
  }

  void _reOrder(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75,
        child: DraggableScrollableSheet(
          initialChildSize: 1.0,
          builder: (BuildContext context, ScrollController scrollController) {
            return ReOrderItemList(
              lineItems: order.lineItems,
            );
          },
        ),
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).yourOrderHasBeenAdded),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
