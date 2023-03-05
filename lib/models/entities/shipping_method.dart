import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../serializers/shipping.dart';

class ShippingMethod {
  String? id;
  String? title;
  String? description;
  double? cost;
  double? shippingTax;
  double? minAmount;
  String? classCost;
  String? methodId;
  String? methodTitle;

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description, 'cost': cost};
  }

  ShippingMethod.fromJson(Map parsedJson) {
    try {
      id = '${parsedJson['id']}';
      title = parsedJson['label'];
      methodId = parsedJson['method_id'];
      methodTitle = parsedJson['label'];
      cost = double.parse("${parsedJson["cost"]}");
      shippingTax = double.parse("${parsedJson["shipping_tax"]}");
    } catch (e) {
      printLog('error parsing Shipping method');
    }
  }

  ShippingMethod.fromNotion(Map parsedJson) {
    try {
      id = '${parsedJson['id']}';
      title = parsedJson['label'];
      methodId = parsedJson['method_id'];
      methodTitle = parsedJson['label'];
      cost = double.parse("${parsedJson["cost"]}") +
          double.parse("${parsedJson["shipping_tax"]}");
    } catch (e) {
      printLog('error parsing Shipping method');
    }
  }

  ShippingMethod.fromMagentoJson(Map parsedJson) {
    id = parsedJson['carrier_code'];
    methodId = parsedJson['method_code'];
    title = parsedJson['carrier_title'] ?? parsedJson['method_title'];
    description = parsedJson['method_title'];
    cost = parsedJson['amount'] != null
        ? double.parse('${parsedJson['amount']}')
        : 0.0;
  }

  ShippingMethod.fromOpencartJson(Map parsedJson) {
    Map<String, dynamic> quote = parsedJson['quote'];
    if (quote['code'] == null &&
        quote.values.isNotEmpty &&
        quote.values.toList()[0] is Map) {
      quote = quote.values.toList()[0];
    }
    String? title = quote['title'] ?? parsedJson['title'];
    id = quote['code'];
    this.title = title ?? id;
    description = title ?? '';
    cost = quote['cost'] != null ? double.parse('${quote['cost']}') : 0.0;
  }

  ShippingMethod.fromShopifyJson(Map parsedJson) {
    id = parsedJson['handle'];
    title = parsedJson['title'];
    description = parsedJson['title'];
    var price = parsedJson['price']['amount'];
    cost = double.parse(price);
  }

  ShippingMethod.fromPrestaJson(Map parsedJson) {
    id = parsedJson['id'].toString();
    title = parsedJson['name'];
    description = parsedJson['delay'];
    cost = double.parse('${parsedJson['shipping_external']}');
  }

  ShippingMethod.fromStrapi(Map<String, dynamic> parsedJson) {
    var model = SerializerShipping.fromJson(parsedJson);
    try {
      id = model.id.toString();
      title = model.title;
      description = model.description;
      cost = model.cost!.toDouble();
    } on Exception catch (e, trace) {
      debugPrint(
          'Error on Strapi shipping model: ${e.toString()}, trace: ${trace.toString()}');
    }
  }

  @override
  String toString() {
    return 'ShippingMethod{id: $id, title: $title, description: $description, cost: $cost, minAmount: $minAmount, classCost: $classCost, methodId: $methodId, methodTitle: $methodTitle}';
  }
}
