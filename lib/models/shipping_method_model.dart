import 'package:flutter/material.dart';
import '../common/config.dart';

import '../models/cart/cart_model.dart';
import '../services/index.dart';
import 'entities/order_delivery_date.dart';
import 'entities/shipping_method.dart';

class ShippingMethodModel extends ChangeNotifier {
  final Services _service = Services();
  List<ShippingMethod>? shippingMethods;
  bool isLoading = true;
  String? message;

  List<OrderDeliveryDate>? _deliveryDates;
  List<OrderDeliveryDate>? get deliveryDates => _deliveryDates;

  Future<void> getShippingMethods(
      {CartModel? cartModel,
      String? token,
      String? checkoutId,
      required String langCode}) async {
    try {
      isLoading = true;
      notifyListeners();
      shippingMethods = await _service.api.getShippingMethods(
          cartModel: cartModel,
          token: token,
          checkoutId: checkoutId,
          langCode: langCode);
      if (kAdvanceConfig.enableDeliveryDateOnCheckout) {
        _deliveryDates = await getDelivery();
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

  Future<List<OrderDeliveryDate>> getDelivery() async {
    return await _service.api.getListDeliveryDates();
  }
}
