import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../services/service_config.dart';
import '../entities/delivery_user.dart';
import '../index.dart';
import '../serializers/product.dart';
import 'commission_data.dart';

class ProductItem {
  String? id;
  String? productId;
  String? variationId;
  String? name;
  int? quantity;
  String? total;
  String? totalTax;
  String? featuredImage;
  Map<String, dynamic> addonsOptions = {};
  List<String?> attributes = [];
  DeliveryUser? deliveryUser;
  List<Map<String, dynamic>?> prodOptions = []; // for opencart
  String? storeId;
  String? storeName;
  Product? product;

  CommissionData? commissionData;
  double? commissionTotal;

  ProductItem.fromJson(Map parsedJson) {
    try {
      productId = parsedJson['product_id'].toString();
      variationId = parsedJson['variation_id'].toString();
      name = parsedJson['name'];
      quantity = int.tryParse("${parsedJson["quantity"]}") ?? 0;
      total = parsedJson['total'];
      totalTax = parsedJson['total_tax'];
      featuredImage = parsedJson['featured_image'];
      if (parsedJson['featured_image'] != null) {
        featuredImage = parsedJson['featured_image'];
      }

      final productData = parsedJson['product_data'];
      if (productData != null) {
        try {
          product = Product.fromJson(productData);
          if (productData['store'] != null) {
            switch (ServerConfig().typeName) {
              case 'wcfm':
                product?.store = Store.fromWCFMJson(productData['store']);
                break;
              case 'dokan':
                product?.store = Store.fromDokanJson(productData['store']);
                break;
              default:
            }
          }
          featuredImage = product!.imageFeature;
        } catch (e) {
          printLog('Error in product_item.dart - $name: $e');
        }
      }

      featuredImage ??= kDefaultImage;

      final metaData = parsedJson['meta_data'] ?? parsedJson['meta'];
      if (metaData is List) {
        if (parsedJson['product_data'] != null &&
            parsedJson['product_data']['type'] == 'appointment') {
          final Map<String, dynamic>? day = metaData.firstWhere(
              (element) =>
                  element['key'] == 'wc_appointments_field_start_date_day',
              orElse: () => null);
          final Map<String, dynamic>? month = metaData.firstWhere(
              (element) =>
                  element['key'] == 'wc_appointments_field_start_date_month',
              orElse: () => null);
          final Map<String, dynamic>? year = metaData.firstWhere(
              (element) =>
                  element['key'] == 'wc_appointments_field_start_date_year',
              orElse: () => null);
          final Map<String, dynamic>? time = metaData.firstWhere(
              (element) =>
                  element['key'] == 'wc_appointments_field_start_date_time',
              orElse: () => null);
          if (day != null && month != null && year != null && time != null) {
            final dateTime = DateTime.parse(
                "${year['value']}-${Tools.getTimeWith2Digit(month['value'])}-${Tools.getTimeWith2Digit(day['value'])} ${time['value']}");
            var appointmentDate = Tools.convertDateTime(dateTime);
            if (appointmentDate != null) {
              addonsOptions['appointment_date'] = appointmentDate;
            }
          }
        } else {
          addonsOptions = {};

          /// Not from Vendor Admin.
          if (parsedJson['meta'] == null &&
              parsedJson['product_data'] != null) {
            final productMetaData = parsedJson['product_data']?['meta_data'];
            for (var item in productMetaData) {
              if (item['key'] == '_product_addons') {
                for (var element in metaData) {
                  if (element['key'].toString().isNotEmpty &&
                      element['key'].toString().substring(0, 1) != '_') {
                    if (element['value'].toString().isNotEmpty) {
                      addonsOptions[element['key'].toString()] =
                          element['value'].toString();
                    }
                  }
                }
                break;
              }
            }
          }

          /// From Vendor Admin.
          if (parsedJson['meta'] != null) {
            for (var element in metaData) {
              if (element['key'].toString().isNotEmpty &&
                  element['key'].toString().substring(0, 1) != '_') {
                addonsOptions[element['key'].toString()] =
                    element['value'].toString();
              }
            }
          }
        }

        for (var attr in metaData) {
          if (attr['key'] == '_vendor_id') {
            storeId = attr['value'];
            storeName = attr['display_value'];
          }
        }
      }

      /// Custom meta_data. Refer to ticket https://support.inspireui.com/mailbox/tickets/9593
      // if (metaData is List) {
      //   addonsOptions = '';
      //   for (var item in metaData) {
      //     if (['attribute_pa_color'].contains(item['key'])) {
      //       if (addonsOptions!.isEmpty) {
      //         addonsOptions = '${item['value']}';
      //       } else {
      //         addonsOptions = '$addonsOptions,${item['value']}';
      //       }
      //     }
      //   }
      // }

      /// For FluxStore Manager
      id = parsedJson['id'].toString();
      if (parsedJson['delivery_user'] != null) {
        deliveryUser = DeliveryUser.fromJson(parsedJson['delivery_user']);
      }

      if (parsedJson['commission'] != null &&
          parsedJson['commission'].isNotEmpty) {
        commissionData = CommissionData.fromMap(parsedJson['commission']);
        if (commissionData!.commissionFixed.isNotEmpty) {
          commissionTotal = ((double.parse(total!) -
                  double.parse(commissionData!.commissionFixed)))
              .abs();
        } else if (commissionData!.commissionPercent.isNotEmpty) {
          commissionTotal = ((double.parse(total!) -
                      double.parse(commissionData!.commissionPercent) *
                          double.parse(total!)) /
                  100)
              .abs();
        }
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromOpencartJson(Map parsedJson) {
    try {
      productId = parsedJson['product_id'].toString();
      name = parsedJson['name'];
      quantity = int.parse("${parsedJson["quantity"]}");
      total = parsedJson['total'];
      if (parsedJson['product_data'] != null) {
        if (parsedJson['product_data']['images'] != null &&
            parsedJson['product_data']['images'].isNotEmpty) {
          featuredImage = parsedJson['product_data']['images'][0];
        }
      }
      if (parsedJson['order_options'] != null) {
        parsedJson['order_options'].forEach((option) {
          prodOptions.add(Map<String, dynamic>.from(option));
        });
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'total': total,
      'featuredImage': featuredImage
    };
  }

  ProductItem.fromLocalJson(Map parsedJson) {
    productId = "${parsedJson["product_id"]}";
    name = parsedJson['name'];
    quantity = parsedJson['quantity'];
    total = parsedJson['total'].toString();
    featuredImage = parsedJson['featuredImage'];
  }

  ProductItem.fromMagentoJson(Map parsedJson) {
    try {
      productId = "${parsedJson["product_id"]}";
      name = parsedJson['name'];
      quantity = parsedJson['qty_ordered'];
      total = parsedJson['base_row_total'].toString();
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromShopifyJson(Map parsedJson) {
    try {
      productId = parsedJson['variant']['product']['id'];
      name = parsedJson['title'];
      quantity = parsedJson['quantity'];
      total = parsedJson['originalTotalPrice']['amount'];
      featuredImage = ((parsedJson['variant'] ?? {})['image'] ?? {})['url'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromPrestaJson(Map parsedJson) {
    try {
      productId = parsedJson['product_id'];
      name = parsedJson['product_name'];
      quantity = int.tryParse(parsedJson['product_quantity']) ?? 0;
      total =
          '${(double.tryParse(parsedJson['unit_price_tax_incl']) ?? 0.0) * (quantity ?? 0)}';
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromStrapiJson(SerializerProduct model, apiLink) {
    try {
      // var model = SerializerProduct.fromJson(parsedJson);
      productId = model.id.toString();
      name = model.title;
      total = model.price.toString();

      var imageList = [];
      if (model.images != null) {
        for (var item in model.images!) {
          imageList.add(apiLink(item.url));
        }
      }
      featuredImage =
          imageList.isNotEmpty ? imageList[0] : apiLink(model.thumbnail!.url);
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromNotionJson(Map parsedJson) {
    try {
      productId = parsedJson['id'].toString();
      quantity = double.parse("${parsedJson["quantity"]}").round();
      total = parsedJson['total'];
      totalTax = parsedJson['total_tax'];
      featuredImage = parsedJson['featured_image'];
      if (parsedJson['featured_image'] != null) {
        featuredImage = parsedJson['featured_image'];
      }

      featuredImage = parsedJson['imageFeature'] ?? '';
      name = parsedJson['name'] ?? '';

      featuredImage ??= kDefaultImage;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  ProductItem.fromBigCommerceJson(Map parsedJson) {
    try {
      productId = parsedJson['product_id']?.toString();
      variationId = parsedJson['variant_id']?.toString();
      name = parsedJson['name'];
      quantity = parsedJson['quantity'];
      total = parsedJson['base_price'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }
}
