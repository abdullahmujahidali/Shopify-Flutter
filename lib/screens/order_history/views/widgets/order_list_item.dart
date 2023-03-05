import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../common/tools.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/index.dart';
import '../../index.dart';

class OrderListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Consumer<OrderHistoryDetailModel>(builder: (_, model, __) {
        final order = model.order;
        final currencyCode =
            order.currencyCode ?? Provider.of<AppModel>(context).currencyCode;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              RouteList.orderDetail,
              arguments: OrderDetailArguments(
                model: model,
              ),
            );
          },
          child: Container(
            width: size.width,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                )
              ],
            ),
            margin: const EdgeInsets.only(
              top: 15.0,
              left: 15.0,
              right: 15.0,
              bottom: 10.0,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
                      ),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (order.lineItems.isNotEmpty &&
                            order.lineItems[0].featuredImage != null)
                          Stack(
                            children: [
                              const SizedBox(width: 92, height: 86),
                              if (order.lineItems.length > 1)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Opacity(
                                    opacity: 0.6,
                                    child: Hero(
                                      tag:
                                          'image-${order.id!}${order.lineItems[1].productId!}',
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                        width: 80,
                                        height: 75,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: ImageResize(
                                            url: order.lineItems[1]
                                                    .featuredImage ??
                                                kDefaultImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Hero(
                                  tag:
                                      'image-${order.id!}${order.lineItems[0].productId!}',
                                  child: Container(
                                    width: 85,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 2),
                                          blurRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: ImageResize(
                                        url: order.lineItems[0].featuredImage ??
                                            kDefaultImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        const SizedBox(width: 10),
                        if (order.lineItems.isNotEmpty)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  Bidi.stripHtmlIfNeeded(
                                    order.lineItems[0].name.toString(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                // Display empty box if Order Address is null
                                order.billing != null
                                    ? Text(
                                        '${order.billing?.firstName} | ${order.billing?.city}, ${order.billing?.country}',
                                        style: const TextStyle(fontSize: 14.0),
                                      )
                                    : const SizedBox(),
                                const Expanded(
                                  child: SizedBox(height: 1),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        S.of(context).createdOn +
                                            DateFormat('d MMM, HH:mm')
                                                .format(order.createdAt!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 12.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.8),
                                            ),
                                      ),
                                    ),
                                    Text(
                                      S.of(context).orderNo +
                                          order.number.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 12.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.8),
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Divider(
                //   height: 1,
                //   color: Theme.of(context).primaryColorLight,
                // ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14.0),
                        bottomRight: Radius.circular(14.0),
                      ),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Theme.of(context).primaryColorLight,
                      ),
                      margin: const EdgeInsets.all(8),
                      padding: EdgeInsets.only(
                          right: Tools.isRTL(context) ? 0.0 : 20,
                          left: !Tools.isRTL(context) ? 0.0 : 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 10,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          OrderStatusWidget(
                            title: S.of(context).total,
                            detail: PriceTools.getCurrencyFormatted(
                                order.total, null,
                                currency: currencyCode),
                          ),
                          OrderStatusWidget(
                            title: S.of(context).tax,
                            detail: PriceTools.getCurrencyFormatted(
                                order.totalTax, null,
                                currency: currencyCode),
                          ),
                          OrderStatusWidget(
                            title: S.of(context).qty,
                            detail: order.quantity.toString(),
                          ),
                          if (order.status != null)
                            OrderStatusWidget(
                              title: S.of(context).status,
                              detail: order.status == OrderStatus.unknown &&
                                      order.orderStatus != null
                                  ? order.orderStatus
                                  : order.status!.content,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class OrderStatusWidget extends StatelessWidget {
  final String? title;
  final String? detail;

  const OrderStatusWidget({Key? key, this.title, this.detail})
      : super(key: key);

  String getTitleStatus(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'onhold':
        return S.of(context).orderStatusOnHold;
      case 'pending':
        return S.of(context).orderStatusPendingPayment;
      case 'failed':
        return S.of(context).orderStatusFailed;
      case 'processing':
        return S.of(context).orderStatusProcessing;
      case 'completed':
        return S.of(context).orderStatusCompleted;
      case 'cancelled':
        return S.of(context).orderStatusCancelled;
      case 'refunded':
        return S.of(context).orderStatusRefunded;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusOrderColor;
    switch (detail!.toLowerCase()) {
      case 'pending':
        {
          statusOrderColor = Colors.red;
          break;
        }
      case 'processing':
        {
          statusOrderColor = Colors.orange;
          break;
        }
      case 'completed':
        {
          statusOrderColor = Colors.green;
          break;
        }
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Text(
              title.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(
                    fontSize: 14.0,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7),
                    fontWeight: FontWeight.w700,
                  )
                  .apply(fontSizeFactor: 0.9),
            ),
          ),
          Expanded(
            child: Text(
              getTitleStatus(detail!, context).capitalize(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: statusOrderColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
