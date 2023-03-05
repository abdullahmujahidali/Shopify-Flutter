import 'package:quiver/strings.dart';

import '../../common/constants.dart';
import '../serializers/payment.dart';

class PaymentMethod {
  String? id;
  String? title;
  String? description;
  bool? enabled;

  PaymentMethod({
    this.id,
    this.title,
    this.description,
    this.enabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'enabled': enabled
    };
  }

  PaymentMethod.fromJson(Map parsedJson) {
    id = parsedJson['id'];
    title = isNotBlank(parsedJson['title'])
        ? parsedJson['title']
        : parsedJson['method_title'];
    description = parsedJson['description'] is String &&
            isNotBlank(parsedJson['description'])
        ? parsedJson['description']
        : null;
    enabled = true;
  }

  PaymentMethod.fromNotion(Map parsedJson) {
    id = parsedJson['id'];
    title = isNotBlank(parsedJson['title'])
        ? parsedJson['title']
        : parsedJson['method_title'];
    description = parsedJson['description'];
    enabled = true;
  }

  PaymentMethod.fromMagentoJson(Map parsedJson) {
    id = parsedJson['code'];
    title = parsedJson['title'];
    description = '';
    enabled = true;
  }

  PaymentMethod.fromOpencartJson(Map parsedJson) {
    id = parsedJson['code'];
    title = parsedJson['title'];
    description = '';
    enabled = true;
  }

  PaymentMethod.fromPrestaJson(Map parsedJson) {
    id = parsedJson['name'];
    title = parsedJson['active'];
    description = '';
    enabled = true;
  }

  PaymentMethod.fromStrapiJson(Map<String, dynamic> parsedJson) {
    var model = SerializerPayment.fromJson(parsedJson);
    try {
      id = model.id.toString();
      title = model.title;
      description = model.description ?? '';
      enabled = true;
    } on Exception catch (e, trace) {
      printLog('Error on Payment Models Strapi: $e trace: ${trace.toString()}');
    }
  }
}
