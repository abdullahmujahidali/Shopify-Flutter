import 'package:flutter/cupertino.dart';

import '../../../data/boxes.dart';
import '../../../models/entities/index.dart';
import '../../../services/index.dart';

class OrderHistoryDetailModel extends ChangeNotifier {
  Order _order;
  List<OrderNote>? _listOrderNote;
  bool _orderNoteLoading = false;
  final User user;
  final _services = Services();

  Order get order => _order;

  List<OrderNote>? get listOrderNote => _listOrderNote;
  bool get orderNoteLoading => _orderNoteLoading;

  OrderHistoryDetailModel({
    required Order order,
    required this.user,
  }) : _order = order {
    fetchImageOfOrder();
  }

  Future<void> fetchImageOfOrder() async {
    await fetchProductItems();
    await fetchImage();
  }

  Future<void> fetchProductItems() async {
    final listProductItem =
        await _services.api.getListProductItemByOrderId(order.id ?? '');
    if (listProductItem.isNotEmpty) {
      _order.lineItems = listProductItem;
      notifyListeners();
    }
  }

  Future<void> fetchImage() async {
    final firstProduct = _order.lineItems.first;
    if (firstProduct.featuredImage?.isEmpty ?? true) {
      final listImage =
          await _services.api.getImagesByProductId(firstProduct.productId!);
      if (listImage.isNotEmpty) {
        firstProduct.featuredImage = listImage.first;
      }
      notifyListeners();
    }
  }

  Future<void> cancelOrder() async {
    if (order.status!.isCancelled) return;
    final newOrder =
        await _services.api.cancelOrder(order: order, userCookie: user.cookie);
    //update local orders for guest
    if (newOrder != null && user.cookie == null) {
      var items = UserBox().orders;
      var list = <Map>[];
      if (items.isNotEmpty) {
        for (var item in items) {
          if (item['id'] == newOrder.id) {
            item['status'] = newOrder.status?.content;
          }
          list.add(item);
        }
      }
      UserBox().orders = list;
    }
    if (newOrder != null) {
      newOrder.lineItems = order
          .lineItems; // fix this issue https://github.com/fluxstore/fluxstore-core/issues/667
      _order = newOrder;
      await fetchImageOfOrder();
      notifyListeners();
    }
  }

  Future<void> createRefund() async {
    if (order.status == OrderStatus.refunded) return;
    await _services.api
        .updateOrder(order.id, status: 'refund-req', token: user.cookie)!
        .then((onValue) {
      _order = onValue;
      Services().firebase.firebaseAnalytics?.logRefund(
            orderId: _order.id,
            price: _order.total,
            currency: _order.currencyCode,
            data: _order.lineItems,
          );
      notifyListeners();
    });
  }

  void getOrderNote() async {
    _orderNoteLoading = true;
    notifyListeners();
    _listOrderNote =
        await _services.api.getOrderNote(userId: user.id, orderId: order.id);
    _orderNoteLoading = false;
    notifyListeners();
  }

// void getTracking() {
//   _services.api.getTracking()?.then((onValue) {
//     for (var track in onValue.trackings) {
//       if (track.orderId == order.number) {
//         tracking = track.trackingNumber;
//         notifyListeners();
//         return;
//       }
//     }
//   });
// }
}
