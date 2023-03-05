import 'dart:async';

import 'package:flutter/material.dart';

import '../models/cart/cart_model.dart';
import '../services/index.dart';
import 'entities/tax.dart';

class TaxModel extends ChangeNotifier {
  final Services _service = Services();
  List<Tax>? taxes = [];
  double taxesTotal = 0;

  Future<void> getTaxes(CartModel cartModel, onSuccess,
      {Function? onError}) async {
    try {
      var res = await _service.api.getTaxes(cartModel);
      if (res != null) {
        taxes = res['items'];
        taxesTotal = double.parse(res['total']);
      }
      onSuccess(taxesTotal, taxes);
    } catch (err) {
      if (onError != null) {
        onError(err);
      }
      notifyListeners();
    }
  }
}
