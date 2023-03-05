import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../services/index.dart';
import '../entities/store_delivery_date.dart';
import '../index.dart';
import '../serializers/order.dart';
import 'fee_item.dart';
import 'user_location.dart';

export 'delivery_status.dart';
export 'product_item.dart';

enum OrderStatus {
  pending,
  processing,
  cancelled,
  refunded,
  completed,
  onHold,
  failed,
  //opencart
  shipped,
  delivered,
  reversed,
  canceled,
  canceledReversal,
  chargeback,
  denied,
  expired,
  processed,
  voided,
  unknown,
  refundRequested,
  driverAssigned,
  outForDelivery,
  orderReturned,
}

class Order {
  String? id;
  String? number;
  OrderStatus? status;
  String?
      orderStatus; //in opencart, order_status will be responsed based on language. so I use this property to show on the UI instead of status property if status is unknown
  DateTime? createdAt;
  DateTime? dateModified;
  double? total;
  double? totalTax;
  double? totalShipping;
  String? paymentMethodTitle;
  String? paymentMethod;
  String? shippingMethodTitle;
  String? customerNote;
  String? customerId;
  List<ProductItem> lineItems = [];
  Address? billing;
  Address? shipping;

  double? subtotal;
  DeliveryStatus? deliveryStatus;
  int quantity = 0;
  Store? wcfmStore;
  UserShippingLocation? userShippingLocation;
  AfterShipTracking? aftershipTracking;
  String? deliveryDate;
  List<StoreDeliveryDate>? storeDeliveryDates;
  List<FeeItem> feeLines = [];
  String? currencyCode;

  int get totalQuantity {
    var quantity = 0;
    for (var item in lineItems) {
      quantity += item.quantity ?? 0;
    }
    return quantity;
  }

  Order({this.id, this.number, this.status, this.createdAt, this.total});

  factory Order.fromJson(Map<String, dynamic>? parsedJson) {
    switch (ServerConfig().type) {
      case ConfigType.opencart:
        return Order._fromOpencartJson(parsedJson!);
      case ConfigType.magento:
        return Order._fromMagentoJson(parsedJson!);
      case ConfigType.shopify:
        return Order._fromShopify(parsedJson!);
      case ConfigType.presta:
        return Order._fromPrestashop(parsedJson!);
      case ConfigType.strapi:
        return Order._fromStrapiJson(parsedJson!);
      case ConfigType.notion:
        return Order._fromNotionJson(parsedJson!);
      case ConfigType.bigCommerce:
        return Order._fromBigCommerceJson(parsedJson!);
      default:
        return Order._fromWooJson(parsedJson!);
    }
  }

  OrderStatus parseOrderStatus(String? status) {
    final newStatus = status?.toLowerCase();
    switch (newStatus) {
      case 'on-hold':
      case 'holded':
        return OrderStatus.onHold;
      case 'canceled reversal':
        return OrderStatus.canceledReversal;
      case 'complete':
        return OrderStatus.completed;
      case 'driver-assigned':
        return OrderStatus.driverAssigned;
      case 'out-for-delivery':
        return OrderStatus.outForDelivery;
      case 'order-returned':
        return OrderStatus.orderReturned;
      case 'refund-req':
        return OrderStatus.refundRequested;
      case 'authorized':
      case 'pending':
      case 'awaiting payment':
        return OrderStatus.pending;
      case 'refunded':
        return OrderStatus.refunded;
      case 'void':
        return OrderStatus.voided;
      default:
        return OrderStatus.values.firstWhere(
          (element) => describeEnum(element) == newStatus,
          orElse: () => OrderStatus.unknown,
        );
    }
  }

  DeliveryStatus parseDeliveryStatus(String? status) {
    final newStatus = status?.toLowerCase();
    return DeliveryStatus.values.firstWhere(
      (element) => describeEnum(element) == newStatus,
      orElse: () => DeliveryStatus.unknown,
    );
  }

  Order._fromWooJson(Map parsedJson) {
    try {
      id = parsedJson['id'].toString();
      customerNote = parsedJson['customer_note'];
      number = parsedJson['number'];
      currencyCode = parsedJson['currency'];
      status = parseOrderStatus(parsedJson['status']);
      createdAt = parsedJson['date_created'] != null
          ? DateTime.parse(parsedJson['date_created'])
          : DateTime.now();
      dateModified = parsedJson['date_modified'] != null
          ? DateTime.parse(parsedJson['date_modified'])
          : DateTime.now();
      total =
          parsedJson['total'] != null ? double.parse(parsedJson['total']) : 0.0;
      totalTax = parsedJson['total_tax'] != null
          ? double.parse(parsedJson['total_tax'])
          : 0.0;
      totalShipping = parsedJson['shipping_total'] != null
          ? double.parse(parsedJson['shipping_total'])
          : 0.0;
      paymentMethodTitle = parsedJson['payment_method_title'];
      paymentMethod = parsedJson['payment_method'];

      parsedJson['line_items']?.forEach((item) {
        lineItems.add(ProductItem.fromJson(item));
        quantity += int.tryParse("${item["quantity"]}") ?? 0;
      });

      parsedJson['fee_lines']?.forEach((item) {
        feeLines.add(FeeItem.fromJson(item));
      });

      billing = Address.fromJson(parsedJson['billing']);
      shipping = Address.fromJson(parsedJson['shipping']);
      shippingMethodTitle = parsedJson['shipping_lines'] != null &&
              parsedJson['shipping_lines'].length > 0
          ? parsedJson['shipping_lines'][0]['method_title']
          : null;
      deliveryStatus = parseDeliveryStatus(parsedJson['delivery_status']);
      if (parsedJson['user_location'] != null) {
        userShippingLocation =
            UserShippingLocation.fromJson(parsedJson['user_location']);
      }
      if (parsedJson['wcfm_store'] != null &&
          parsedJson['wcfm_store'] is Map &&
          parsedJson['wcfm_store']['vendor_shop_name'].toString().isNotEmpty) {
        wcfmStore = Store.fromWCFMJson(parsedJson['wcfm_store']);
      }
      if (parsedJson['store'] != null && parsedJson['store'] is Map) {
        wcfmStore = Store.fromDokanJson(parsedJson['store']);
      }
      customerId = parsedJson['customer_id'].toString();

      /// GET AFTERSHIP TRACKING & DELIVERY DATE
      if (parsedJson['meta_data'] != null) {
        var providerName = '';
        var trackingNumber = '';
        for (var item in parsedJson['meta_data']) {
          if (item['key'] == '_aftership_tracking_number') {
            trackingNumber = item['value'];
          }
          if (item['key'] == '_aftership_tracking_provider_name') {
            providerName = item['value'];
          }
          if (item['key'] == '_orddd_timestamp') {
            var format = DateFormat('dd-MM-yyyy');
            if (item['value'] != null && item['value'].isNotEmpty) {
              var timeStamp = int.parse(item['value'].toString());
              timeStamp = timeStamp * 1000;
              deliveryDate = format.format(
                DateTime.fromMillisecondsSinceEpoch(timeStamp),
              );
            }
          }
          if (item['key'] == '_wcfmd_delvery_times') {
            storeDeliveryDates = [];
            final deliveryDateMap = item['value'];
            if (deliveryDateMap is Map) {
              deliveryDateMap.forEach((key, value) {
                storeDeliveryDates!
                    .add(StoreDeliveryDate(storeId: key, dateTime: value));
              });
            }
          }
        }
        if (!providerName.isEmptyOrNull && !trackingNumber.isEmptyOrNull) {
          aftershipTracking = AfterShipTracking(trackingNumber, providerName);
        }
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromNotionJson(Map parsedJson) {
    try {
      final properties = parsedJson['properties'];
      id = parsedJson['id'];
      final note = NotionDataTools.fromRichText(properties['Notes']);
      customerNote = (note ?? []).join('');

      number = '${NotionDataTools.fromNumber(properties['Number']) ?? '--'}';
      status = parseOrderStatus(
          NotionDataTools.fromRichTextToText(properties['Status']) ??
              'pending');
      final dateCreated = properties['CreatedAt'] != null
          ? NotionDataTools.fromDate(properties['CreatedAt'])
          : DateTime.now().toString();
      createdAt =
          dateCreated != null ? DateTime.parse(dateCreated) : DateTime.now();
      dateModified = DateTime.now();
      total = double.parse(
          '${NotionDataTools.fromNumber(properties['TotalPrice']) ?? 0.0}');

      totalTax = 0.0;
      totalShipping = double.parse(
          '${NotionDataTools.fromNumber(properties['ShippingTotal']) ?? 0.0}');
      paymentMethodTitle = NotionDataTools.fromRichTextToText(
              properties['PaymentMethodTitle']) ??
          '';

      /// load data product
      final listProducts = <Product>[];
      if (properties['Products'] != null && properties['Products'] is List) {
        for (var item in properties['Products']) {
          listProducts.add(Product.fromNotion(item));
        }
      }

      /// LoadItem
      final dataItems = NotionDataTools.fromRichText(properties['Items']);
      if (dataItems?.isNotEmpty ?? false) {
        final dataTextItemProduct = dataItems!.join('');
        final dataRawListItem =
            dataTextItemProduct.split(NotionDataTools.newlineListData);
        if (dataRawListItem.isNotEmpty) {
          for (var itemProduct in dataRawListItem) {
            if (itemProduct.isNotEmpty) {
              final lineData = itemProduct.split('\n');
              final mapDataItem = <String, dynamic>{};
              for (var item in lineData) {
                final dataRaw = item.split(':');
                mapDataItem.addAll({
                  dataRaw.first: dataRaw.last,
                });
              }

              final indexProduct = listProducts
                  .indexWhere((element) => element.id == mapDataItem['id']);

              if (indexProduct != -1) {
                final product = listProducts[indexProduct];
                mapDataItem['imageFeature'] = product.imageFeature;
                mapDataItem['name'] = product.name;
              }

              quantity += double.parse("${mapDataItem["quantity"]}").round();
              lineItems.add(ProductItem.fromNotionJson(mapDataItem));
            }
          }
        }
      }

      final dataBilling =
          NotionDataTools.fromRichTextToText(properties['Billing']) ?? '{}';
      final dataRawBilling = dataBilling.split('\n');
      if (dataRawBilling.isNotEmpty) {
        final mapDataBilling = <String, dynamic>{};
        for (var item in dataRawBilling) {
          final dataRaw = item.split(':');
          mapDataBilling.addAll({
            dataRaw.first: dataRaw.last,
          });
        }
        billing = Address.fromJson(mapDataBilling);
      }

      final dataShipping =
          NotionDataTools.fromRichTextToText(properties['Shipping']) ?? '{}';
      final dataRawShipping = dataShipping.split('\n');
      if (dataRawShipping.isNotEmpty) {
        final mapDataShipping = <String, dynamic>{};
        for (var item in dataRawShipping) {
          final dataRaw = item.split(':');
          mapDataShipping.addAll({
            dataRaw.first: dataRaw.last,
          });
        }
        shipping = Address.fromJson(mapDataShipping);
      }

      final dataShippingLines = [];
      final dataRawShippingLines =
          NotionDataTools.fromRichText(properties['ShippingLines']);
      if (dataRawShippingLines?.isNotEmpty ?? false) {
        for (var itemRawShippingLine in dataRawShippingLines!) {
          final dataRawLine = itemRawShippingLine.split('\n');
          if (dataRawLine.isNotEmpty) {
            final mapDataShippingLine = <String, dynamic>{};
            for (var item in dataRawLine) {
              final dataRaw = item.split(':');
              mapDataShippingLine.addAll({
                dataRaw.first: dataRaw.last,
              });
            }
            dataShippingLines.add(mapDataShippingLine);
          }
        }
      }

      shippingMethodTitle = dataShippingLines.isNotEmpty
          ? dataShippingLines[0]['method_title']
          : null;

      deliveryStatus =
          parseDeliveryStatus(properties['delivery_status'] ?? 'pending');
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromOpencartJson(Map parsedJson) {
    try {
      id = parsedJson['order_id'].toString();
      number = parsedJson['order_id'];
      status = parseOrderStatus(parsedJson['order_status']);
      if (status == OrderStatus.unknown) {
        orderStatus = parsedJson['order_status'];
      }
      createdAt = parsedJson['date_added'] != null
          ? DateTime.parse(parsedJson['date_added'])
          : DateTime.now();
      dateModified = parsedJson['date_modified'] != null
          ? DateTime.parse(parsedJson['date_modified'])
          : DateTime.now();
      total =
          parsedJson['total'] != null ? double.parse(parsedJson['total']) : 0.0;
      totalTax = 0.0;
      paymentMethodTitle = parsedJson['payment_method'];
      shippingMethodTitle = parsedJson['shipping_method'];
      customerNote = parsedJson['comment'];
      parsedJson['line_items']?.forEach((item) {
        lineItems.add(ProductItem.fromOpencartJson(item));
        quantity += int.parse("${item["quantity"]}");
      });
      billing = Address.fromOpencartOrderJson(parsedJson);
      shipping = billing;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromMagentoJson(Map parsedJson) {
    try {
      id = parsedJson['entity_id'].toString();
      number = "${parsedJson["increment_id"]}";
      status = parseOrderStatus(parsedJson['status']);
      createdAt = parsedJson['created_at'] != null
          ? DateTime.parse(parsedJson['created_at'])
          : DateTime.now();
      total = parsedJson['base_grand_total'] != null
          ? double.parse("${parsedJson["base_grand_total"]}")
          : 0.0;
      paymentMethodTitle = parsedJson['payment']['additional_information'][0];
      shippingMethodTitle = parsedJson['shipping_description'];
      totalShipping = parsedJson['shipping_incl_tax'] != null
          ? double.parse("${parsedJson['shipping_incl_tax']}")
          : 0.0;
      totalTax = parsedJson['tax_amount'] != null
          ? double.parse("${parsedJson['tax_amount']}")
          : 0.0;
      parsedJson['items']?.forEach((item) {
        quantity += int.parse('${item['qty_ordered']}');
        lineItems.add(ProductItem.fromMagentoJson(item));
      });
      billing = Address.fromMagentoJson(parsedJson['billing_address']);
      shipping = billing;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromShopify(Map parsedJson) {
    try {
      id = parsedJson['id'];
      number = "${parsedJson["orderNumber"]}";
      status = parseOrderStatus(parsedJson['financialStatus']);

      createdAt = DateTime.parse(parsedJson['processedAt']).toLocal();
      total = double.parse(parsedJson['totalPrice']['amount']);
      paymentMethodTitle = '';
      shippingMethodTitle = '';
      // statusUrl = parsedJson['statusUrl'];

      var totalTaxV2 = parsedJson['totalTax']['amount'] ?? '0';
      totalTax = double.parse(totalTaxV2);
      var subtotalTaxV2 = parsedJson['subtotalPrice']['amount'] ?? '0';
      subtotal = double.parse(subtotalTaxV2);

      var items = parsedJson['lineItems']['edges'];
      items.forEach((item) {
        final productItem = ProductItem.fromShopifyJson(item['node']);
        quantity += productItem.quantity ?? 0;
        lineItems.add(productItem);
      });
      billing = Address.fromShopifyJson(parsedJson['shippingAddress']);
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromPrestashop(Map parsedJson) {
    try {
      id = parsedJson['id'].toString();
      number = "${parsedJson["id"]}";
      switch (parsedJson['status']) {
        case 'Payment accepted':
        case 'Processing in progress':
        case 'Remote payment accepted':
        case 'Awaiting for PayPal payment':
        case 'Awaiting Cash On Delivery validation':
        case 'Awaiting check payment':
        case 'Awaiting bank wire payment':
          status = OrderStatus.processing;
          break;
        case 'Shipped':
        case 'Delivered':
          status = OrderStatus.delivered;
          break;
        case 'Canceled':
          status = OrderStatus.canceled;
          break;
        case 'Refunded':
          status = OrderStatus.refunded;
          break;
        case 'Payment error':
          status = OrderStatus.failed;
          break;
        case 'On backorder (paid)':
        case 'On backorder (not paid)':
          status = OrderStatus.denied;
          break;
        default:
          status = parseOrderStatus(parsedJson['status']);
      }
      createdAt = DateTime.parse(parsedJson['date_add']);
      total = double.tryParse(parsedJson['total_paid'].toString());
      paymentMethodTitle = parsedJson['payment'];
      shippingMethodTitle = parsedJson['shipping_method'] ?? '';

      totalTax = double.tryParse(parsedJson['total_shipping'].toString());
      subtotal = 0;

      var items = parsedJson['associations']['order_rows'];
      items.forEach((item) {
        var productItem = ProductItem.fromPrestaJson(item);
        lineItems.add(productItem);
        quantity += productItem.quantity ?? 0;
      });
      billing = Address.fromPrestaJson(parsedJson['address'] ?? {});
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order._fromStrapiJson(Map<String, dynamic> parsedJson) {
    try {
      var model = SerializerOrder.fromJson(parsedJson);
      id = model.id.toString();
      number = model.id.toString();
      status = null;
      createdAt = DateTime.parse(model.createdAt!);
      total = model.total;
      paymentMethodTitle = model.payment!.title;
      shippingMethodTitle = model.shipping!.title;
      customerNote = '';

      /// this funciton should be move to framework
      // List<dynamic> itemList = model.products!;
      // itemList.forEach((item) {
      //   lineItems
      //       .add(ProductItem.fromStrapiJson(item, Strapi().strapiAPI.apiLink));
      // });
      totalTax = 0.0;
      subtotal = 0.0;
    } on Exception catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Order.fromLocalJson(Map parsedJson) {
    id = parsedJson['id'];
    number = parsedJson['number'];
    status = parseOrderStatus(parsedJson['status']);
    createdAt = parsedJson['date_created'] != null
        ? DateTime.parse(parsedJson['date_created'])
        : DateTime.now();
    total =
        parsedJson['total'] != null ? double.parse(parsedJson['total']) : 0.0;
    totalTax = parsedJson['totalTax'] != null
        ? double.parse(parsedJson['totalTax'])
        : 0.0;
    paymentMethodTitle = parsedJson['payment_method_title'];

    parsedJson['line_items']?.forEach((item) {
      lineItems.add(ProductItem.fromLocalJson(item));
      quantity += int.parse("${item["quantity"]}");
    });

    billing = Address.fromLocalJson(parsedJson['billing']);
    shipping = Address.fromLocalJson(parsedJson['shipping']);
    shippingMethodTitle = parsedJson['shipping_lines'] != null &&
            parsedJson['shipping_lines'].length > 0
        ? parsedJson['shipping_lines'][0]['method_title']
        : null;
  }

  Map<String, dynamic> toOrderJson(CartModel cartModel, userId) {
    var items = lineItems.map((index) {
      return index.toJson();
    }).toList();

    return {
      'status': status!.content,
      'total': total.toString(),
      'totalTax': totalTax.toString(),
      'shipping_lines': [
        {'method_title': shippingMethodTitle}
      ],
      'number': number,
      'billing': billing?.toJson(),
      'shipping': shipping?.toJson(),
      'line_items': items,
      'id': id,
      'date_created': createdAt.toString(),
      'payment_method_title': paymentMethodTitle
    };
  }

  Map<String, dynamic> toJson(CartModel cartModel, userId, paid) {
    var hasAddonsOptions = false;
    var isWalletCart = cartModel.isWalletCart();

    var lineItems = cartModel.productsInCart.keys.map((key) {
      var productId = Product.cleanProductID(key);
      var productVariantId = ProductVariation.cleanProductVariantID(key);

      var product = cartModel.item[productId];
      var itemPrice =
          cartModel.getProductPrice(key) + cartModel.getProductAddonsPrice(key);
      itemPrice = PriceTools.getPriceValueByCurrency(
          itemPrice,
          cartModel.currencyCode ??
              kAdvanceConfig.defaultCurrency?.currencyCode ??
              'USD',
          cartModel.currencyRates ?? {});
      var item = {
        'product_id': productId,
        'quantity': cartModel.productsInCart[key],
        'subtotal': '$itemPrice',
        'total': '$itemPrice'
      };

      var attrNames = <String?>[];
      if (cartModel.productVariationInCart[key] != null &&
          productVariantId != null) {
        item['variation_id'] = cartModel.productVariationInCart[key]!.id;

        for (var element in cartModel.productVariationInCart[key]!.attributes) {
          if (element.id != null) {
            attrNames.add(element.name);
          }
        }
      }

      if (cartModel.productsMetaDataInCart[key] != null) {
        var metaData = <Map<String, dynamic>>[];
        cartModel.productsMetaDataInCart[key].forEach((k, v) {
          if (!attrNames.contains(k)) {
            for (var element in product!.attributes!) {
              if (element.name?.toLowerCase() == k.toString().toLowerCase()) {
                Map<String, dynamic>? option = Map.from(element.options!
                    .firstWhere((e) => e['name'] == v, orElse: () => {}));
                if (option.isNotEmpty) {
                  metaData.add({
                    'key':
                        'attribute_${element.slug ?? option['taxonomy'] ?? element.name}',
                    'value': option['slug'] ?? option['name']
                  });
                }
              }
            }
          }
        });
        item['meta_data'] = metaData;
      }
      if (product!.bookingInfo != null) {
        var metaData = item['meta_data'] as List<Map<String, dynamic>>? ?? [];
        var bookingInfo = product.bookingInfo!.toJsonAPI();
        for (var key in bookingInfo.keys) {
          metaData.add({'key': key, 'value': bookingInfo[key]});
        }
        item['meta_data'] = metaData;
      }

      if (cartModel.productAddonsOptionsInCart[key] != null &&
          cartModel.productAddonsOptionsInCart[key]!.isNotEmpty) {
        hasAddonsOptions = true;
        var metaData = item['meta_data'] as List<Map<String, dynamic>>? ?? [];
        var itemPrice = cartModel.getProductPrice(key);
        final options = cartModel.productAddonsOptionsInCart[key]!;
        var addons = {};

        for (var option in options) {
          //save options to addons to show on the webview
          final fieldName = 'addon-${option.fieldName}';
          var fieldLabel = (option.label ?? '').toLowerCase();
          if (option.type == 'multiple_choice' && option.display == 'select') {
            fieldLabel += '-${(option.index ?? '1')}';
          }
          if (addons[fieldName] == null) {
            addons[fieldName] = fieldLabel;
          } else if (addons[fieldName] is List) {
            addons[fieldName] = [...addons[fieldName], fieldLabel];
          } else {
            addons[fieldName] = [addons[fieldName], fieldLabel];
          }

          final price = PriceTools.getCurrencyFormatted(
              option.price ?? 0.0, cartModel.currencyRates,
              currency: cartModel.currencyCode);
          metaData.add({
            'key':
                "${option.parent}${(option.price?.isNotEmpty ?? false) ? ' ($price)' : ''}",
            'value': option.label,
          });
          itemPrice += double.tryParse(option.price ?? '0.0') ?? 0;
        }

        addons['quantity'] = item['quantity'];
        addons['add-to-cart'] = productId;
        item['addons'] = addons;

        item['subtotal'] = '$itemPrice';
        item['total'] = '$itemPrice';
      }

      if (isWalletCart) {
        var itemPrice = cartModel.getProductPrice(key);
        item['subtotal'] = '$itemPrice';
        item['total'] = '$itemPrice';
      }
      return item;
    }).toList();

    var params = {
      'set_paid': paid,
      'line_items': lineItems,
      'customer_id': userId,
      'currency': cartModel.currencyCode?.toUpperCase(),
    };
    try {
      if (cartModel.paymentMethod != null) {
        params['payment_method'] = cartModel.paymentMethod!.id;
      }
      if (cartModel.paymentMethod != null) {
        params['payment_method_title'] = cartModel.paymentMethod!.title;
      }
      if (paid) params['status'] = 'processing';

      if (cartModel.address != null &&
          cartModel.address!.mapUrl != null &&
          cartModel.address!.mapUrl!.isNotEmpty &&
          kPaymentConfig.enableAddressLocationNote) {
        params['customer_note'] = 'URL:${cartModel.address!.mapUrl!}';
      }
      if (kEnableCustomerNote &&
          cartModel.notes != null &&
          cartModel.notes!.isNotEmpty) {
        if (params['customer_note'] != null) {
          params['customer_note'] += '\n${cartModel.notes!}';
        } else {
          params['customer_note'] = cartModel.notes;
        }
      }

      if (kPaymentConfig.enableAddress && cartModel.address != null) {
        params['billing'] = cartModel.address!.toJson();
        if (ServerConfig().type == ConfigType.wcfm) {
          params['shipping'] = cartModel.address!.toWCFMJson();
        } else {
          params['shipping'] = cartModel.address!.toJson();
        }
        params['billing'].removeWhere((key, value) => value == null);
        params['shipping'].removeWhere((key, value) => value == null);
      }

      var isMultiVendor = ServerConfig().typeName.isMultiVendor;
      if (isMultiVendor) {
        if (kPaymentConfig.enableShipping &&
            cartModel.selectedShippingMethods.isNotEmpty) {
          var shippings = <Map<String, dynamic>>[];
          for (var element in cartModel.selectedShippingMethods) {
            final shippingFee = PriceTools.getPriceValueByCurrency(
                element.shippingMethods[0].cost,
                cartModel.currencyCode ??
                    kAdvanceConfig.defaultCurrency?.currencyCode ??
                    'USD',
                cartModel.currencyRates ?? {});
            shippings.add({
              'method_id': '${element.shippingMethods[0].id}',
              'method_title': element.shippingMethods[0].title,
              'total': '$shippingFee'
            });
          }
          params['shipping_lines'] = shippings;
        }
      } else {
        if (kPaymentConfig.enableShipping && cartModel.shippingMethod != null) {
          final shippingFee = PriceTools.getPriceValueByCurrency(
              cartModel.getShippingCost(),
              cartModel.currencyCode ??
                  kAdvanceConfig.defaultCurrency?.currencyCode ??
                  'USD',
              cartModel.currencyRates ?? {});
          params['shipping_lines'] = [
            {
              'method_id': cartModel.shippingMethod!.id,
              'method_title': cartModel.shippingMethod!.title,
              'total': shippingFee.toString()
            }
          ];
        }
      }

      var feeLines = [];
      if (cartModel.rewardTotal > 0) {
        feeLines.add({
          'name': 'Cart Discount',
          'tax_status': 'taxable',
          'total': '${cartModel.rewardTotal * (-1)}',
          'amount': '${cartModel.rewardTotal * (-1)}'
        });
      }
      if (cartModel.walletAmount > 0) {
        feeLines.add({
          'name': 'Via Wallet',
          'tax_status': 'taxable',
          'total': '${cartModel.walletAmount * (-1)}',
          'amount': '${cartModel.walletAmount * (-1)}'
        });
        params['total'] = cartModel.getTotal();
      }
      if (cartModel.getCODExtraFee() > 0) {
        feeLines.add({
          'name': 'COD Extra Fee',
          'tax_status': 'taxable',
          'total': '${cartModel.getCODExtraFee()}',
          'amount': '${cartModel.getCODExtraFee()}'
        });
      }
      if (feeLines.isNotEmpty) {
        params['fee_lines'] = feeLines;
      }
      if (cartModel.couponObj != null) {
        params['coupon_lines'] = [
          {'code': cartModel.couponObj!.code}
        ];
      }

      if (hasAddonsOptions ||
          cartModel.couponObj != null ||
          cartModel.walletAmount > 0.0) {
        params['subtotal'] = cartModel.getSubTotal();
        params['total'] = cartModel.getTotal();
      }

      if (kAdvanceConfig.enableDeliveryDateOnCheckout) {
        params['meta_data'] = [];
        if (cartModel.selectedDate != null) {
          params['meta_data'].addAll([
            {
              'key': 'Delivery Date',
              'value': cartModel.selectedDate!.dateString!,
            },
            {
              'key': '_orddd_timestamp',
              'value': cartModel.selectedDate!.timeStamp,
            },
            {
              'key': '_orddd_delivery_schedule_id',
              'value': '0',
            },
          ]);
        }
        if (cartModel.selectedDateByStoreId.isNotEmpty) {
          var value = {};
          cartModel.selectedDateByStoreId.forEach((k, v) {
            value[k] = v.timeStamp;
          });
          params['meta_data']
              .add({'key': '_wcfmd_delvery_times', 'value': value});
        }
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }

    return params;
  }

  Order._fromBigCommerceJson(Map parsedJson) {
    try {
      id = parsedJson['id']?.toString();
      customerId = parsedJson['customer_id']?.toString();
      // TODO: parse date time RFC-2822.
      // createdAt = parsedJson['date_created'] != null
      //     ? DateTime.parse(parsedJson['date_created'])
      //     : DateTime.now();
      // dateModified = parsedJson['date_modified'] != null
      //     ? DateTime.parse(parsedJson['date_modified'])
      //     : DateTime.now();
      createdAt = DateTime.now();
      dateModified = DateTime.now();
      totalTax = parsedJson['total_tax'] != null
          ? double.parse(parsedJson['total_tax'])
          : 0.0;
      billing = Address.fromJson(parsedJson['billing_address']);

      number = id;
      customerNote = parsedJson['customer_message'];
      customerId = parsedJson['customer_id']?.toString();
      paymentMethodTitle = parsedJson['payment_status'];
      paymentMethod = parsedJson['payment_method'];
      // TODO: parse status.
      quantity = int.tryParse('${parsedJson['items_total']}') ?? 0;
      status = parseOrderStatus(parsedJson['status']);
      total = parsedJson['total_inc_tax'] != null
          ? double.parse(parsedJson['total_inc_tax'])
          : 0.0;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Map<String, dynamic> toMagentoJson(CartModel cartModel, userId, paid) {
    return {
      'set_paid': paid,
      'paymentMethod': {'method': cartModel.paymentMethod!.id},
      'billing_address': cartModel.address!.toMagentoJson()['address'],
    };
  }

  Map<String, dynamic> toNotiontoJson(int idNotionOrder, CartModel cartModel,
      String userId, String nameUser, bool paid, transactionId) {
    final params = toJson(cartModel, userId, paid);

    if (transactionId != null) {
      params['transaction_id'] = transactionId;
    }

    var discountTotal = 0.0;
    var total = 0.0;

    final productRelationId = <String>[];
    final listDataRawItem = [];
    for (var item in params['line_items']) {
      if (item != null && item is Map) {
        final productId = '${item['product_id']}';
        productRelationId.add(productId);
        final quantity = (item['quantity'] ?? 0.0) * 1.0;
        final product = cartModel.item[productId];
        final price = double.parse('${product?.price ?? 0}');
        final regularPrice = double.parse('${product?.regularPrice ?? 0}');
        if (regularPrice > price) {
          discountTotal = discountTotal + (regularPrice - price);
        }

        final dataItem = {
          'quantity': quantity,
          'subtotal': '$price',
          'total': '${quantity * price}',
          'price': price,
          'id': product?.id
        };
        listDataRawItem.add(dataItem);
        total = total + (price * quantity);
      }
    }

    final statusOrder = paid ? 'processing' : 'pending';
    var billing = '';
    (params['billing'] as Map).forEach((key, value) {
      billing = '$billing$key:$value\n';
    });

    var shipping = '';
    (params['shipping'] as Map).forEach((key, value) {
      shipping = '$shipping$key:$value\n';
    });

    final shippingLine = <String>[];
    for (var item in params['shipping_lines'] as List) {
      var itemLine = '';
      if (item != null && item is Map) {
        item.forEach((key, value) {
          itemLine = '$itemLine$key:$value\n';
        });
      }
      if (itemLine.isNotEmpty) {
        shippingLine.add(itemLine);
      }
    }

    final dataItems = <String>[];
    for (var item in listDataRawItem) {
      var itemLine = '';
      if (item != null && item is Map) {
        item.forEach((key, value) {
          itemLine = '$itemLine$key:$value\n';
        });
      }
      if (itemLine.isNotEmpty) {
        dataItems.add(itemLine);
        dataItems.add(NotionDataTools.newlineListData);
      }
    }

    var noteOrder = <String>[];
    if (cartModel.notes?.isNotEmpty ?? false) {
      noteOrder.add('CustomerNote: ${cartModel.notes!}\n');
      noteOrder.add(NotionDataTools.newlineListData);
    }
    if (cartModel.productVariationInCart.isNotEmpty) {
      cartModel.productVariationInCart.forEach((key, value) {
        if (value != null) {
          noteOrder.add('id:${key.substring(0, NotionDataTools.lengthId)}\n');
          for (var attr in value.attributes) {
            noteOrder.add('${attr.name}:${attr.option}\n');
          }
          noteOrder.add(NotionDataTools.newlineListData);
        }
      });
    }

    var deliveryDate = {};
    if (cartModel.selectedDate != null) {
      deliveryDate = {
        'DeliveryDate': NotionDataTools.toDate(
            DateTime.parse(cartModel.selectedDate!.deliveryDate!))
      };
    }

    return {
      'Name':
          NotionDataTools.toTitle('$nameUser($userId)-OrderNo.#$idNotionOrder'),
      'Customer': NotionDataTools.toRelation([userId]),
      'PaymentMethod': NotionDataTools.toRichText(params['payment_method']),
      ...deliveryDate,
      'PaymentMethodTitle':
          NotionDataTools.toRichText(params['payment_method_title']),
      'ShippingLines': NotionDataTools.listStringToRichText(shippingLine),
      'Items': NotionDataTools.listStringToRichText(dataItems),
      'Products': NotionDataTools.toRelation(productRelationId),
      'Billing': NotionDataTools.listStringToRichText([billing]),
      'Shipping': NotionDataTools.listStringToRichText([shipping]),
      'TotalPrice': NotionDataTools.toNumber(total),
      'SetPaid': NotionDataTools.toCheckBox(paid),
      'Number': NotionDataTools.toNumber(idNotionOrder),
      'DiscountTotal': NotionDataTools.toNumber(discountTotal),
      'Currency': NotionDataTools.toRichText('${cartModel.currencyCode}'),
      'ShippingTotal':
          NotionDataTools.toNumber(cartModel.shippingMethod?.cost ?? 0),
      'CreatedAt': NotionDataTools.toDate(DateTime.now()),
      'Status': NotionDataTools.toRichText(statusOrder),
      if (noteOrder.isNotEmpty)
        'Notes': NotionDataTools.listStringToRichText(noteOrder),
    };
  }

  Map<String, dynamic> toBigCommerceJson(CartModel cartModel, userId, paid) {
    final result = <String, dynamic>{};
    final items = <Map<String, dynamic>>[];

    if (userId != null) {
      result['customer_id'] = Helper.formatInt(userId);
    }

    for (var key in cartModel.productsInCart.keys) {
      final productId = Product.cleanProductID(key);
      var productVariantId = ProductVariation.cleanProductVariantID(key);

      final item = <String, dynamic>{
        'product_id': Helper.formatInt(productId),
        'quantity': cartModel.productsInCart[key],
        // TODO: support modifier.
        // https://developer.bigcommerce.com/api-reference/b3A6MzU5MDQxOTM-create-a-cart
        // 'option_selections': [],
      };
      if (cartModel.productVariationInCart[key] != null &&
          productVariantId != null) {
        item['variant_id'] = cartModel.productVariationInCart[key]!.id;
      }

      items.add(item);
    }

    result['line_items'] = items;
    return result;
  }

  Map<String, dynamic> toIAPWooJson(
      Product product,
      int quantity,
      ProductVariation? productVariation,
      Map<String?, String?> mapAttribute,
      userId) {
    var lineItem = {'product_id': product.id, 'quantity': quantity};
    if (productVariation?.id?.isNotEmpty ?? false) {
      lineItem['variation_id'] = productVariation!.id!;
    }

    var params = {
      'set_paid': true,
      'line_items': [lineItem],
      'customer_id': userId,
      'payment_method': 'In App Purchase',
      'status': 'processing'
    };
    return params;
  }

  @override
  String toString() => 'Order { id: $id  number: $number}';
}

extension OrderStatusExtension on OrderStatus {
  bool get isCancelled => [
        OrderStatus.cancelled,
        // OrderStatus.canceled,
      ].contains(this);

  String get content => describeEnum(this);

  Color get displayColor {
    switch (this) {
      case OrderStatus.pending:
        return Colors.amber;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.cancelled:
      case OrderStatus.canceled:
        return Colors.grey;
      case OrderStatus.refunded:
        return Colors.red;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.onHold:
        return Colors.blue;
      case OrderStatus.driverAssigned:
        return Colors.lime;
      default:
        return Colors.yellow;
    }
  }

  String getTranslation(context) {
    switch (this) {
      case OrderStatus.pending:
        return S.of(context).orderStatusPending;
      case OrderStatus.processing:
        return S.of(context).orderStatusProcessing;
      case OrderStatus.cancelled:
      case OrderStatus.canceled:
        return S.of(context).orderStatusCancelled;
      case OrderStatus.refunded:
        return S.of(context).orderStatusRefunded;
      case OrderStatus.completed:
        return S.of(context).orderStatusCompleted;
      case OrderStatus.onHold:
        return S.of(context).orderStatusOnHold;
      case OrderStatus.shipped:
        return S.of(context).orderStatusShipped;
      case OrderStatus.reversed:
        return S.of(context).orderStatusReversed;
      case OrderStatus.canceledReversal:
        return S.of(context).orderStatusCanceledReversal;
      case OrderStatus.chargeback:
        return S.of(context).orderStatusChargeBack;
      case OrderStatus.denied:
        return S.of(context).orderStatusDenied;
      case OrderStatus.expired:
        return S.of(context).orderStatusExpired;
      case OrderStatus.processed:
        return S.of(context).orderStatusProcessed;
      case OrderStatus.voided:
        return S.of(context).orderStatusVoided;
      case OrderStatus.refundRequested:
        return S.of(context).refundRequested;
      case OrderStatus.driverAssigned:
        return S.of(context).driverAssigned;
      default:
        return S.of(context).orderStatusFailed;
    }
  }
}
