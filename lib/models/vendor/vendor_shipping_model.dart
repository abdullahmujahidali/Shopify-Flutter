import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../services/index.dart';
import '../cart/cart_model.dart';
import '../entities/order_delivery_date.dart';
import '../entities/shipping_method.dart';
import 'store_model.dart';

class VendorShippingMethodModel extends ChangeNotifier {
  final Services _service = Services();
  List<VendorShippingMethod> list = [];
  bool isLoading = true;
  String? message;

  final Map<int?, List<OrderDeliveryDate>> _deliveryDatesMV = {};
  Map<int?, List<OrderDeliveryDate>>? get deliveryDatesMV => _deliveryDatesMV;

  List<OrderDeliveryDate>? _deliveryDates;
  List<OrderDeliveryDate>? get deliveryDates => _deliveryDates;

  Future<void> getShippingMethods(
      {CartModel? cartModel, required List<Store?> stores, String? langCode}) async {
    try {
      isLoading = true;
      list = [];
      notifyListeners();
      for (var i = 0; i < stores.length; i++) {
        final store = stores[i];
        var items = await _service.api
            .getShippingMethods(cartModel: cartModel, store: store, langCode: langCode)!;
        if (items.isNotEmpty) {
          list.add(VendorShippingMethod(store, items));
        }
      }
      if ((kAdvanceConfig.enableDeliveryDateOnCheckout) &&
          ServerConfig().typeName.isWcfm) {
        for (var i = 0; i < stores.length; i++) {
          final store = stores[i];
          if (store != null) {
            _deliveryDatesMV[store.id] = await getDelivery(storeId: store.id);
          }
        }
      }

      isLoading = false;
      message = null;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      message = '⚠️ $err';
      notifyListeners();
    }
  }

  Future<List<OrderDeliveryDate>> getDelivery({storeId}) async {
    return await _service.api.getListDeliveryDates(storeId: storeId);
  }
}

class VendorShippingMethod {
  Store? store;
  List<ShippingMethod> shippingMethods = [];

  VendorShippingMethod(this.store, this.shippingMethods);
}
