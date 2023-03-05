import '../order/order.dart';

class WCFMNotification {
  String? iD;
  String? message;
  String? messageType;
  String? productName;
  String? deliveryMessage;
  String? created;
  String? orderId;
  Order? order;

  WCFMNotification({this.iD, this.message, this.messageType, this.created});

  WCFMNotification.fromJson(Map json) {
    iD = json['ID'];
    message = json['message'];

    try {
      var exp = RegExp(r'\B#\d\d+');
      orderId = exp.firstMatch(message!)!.group(0);
      orderId = orderId!.replaceAll('#', '');
    } catch (e) {
      orderId = '';
    }
    messageType = json['message_type'];
    messageType = messageType!.replaceAll('_', ' ');
    messageType = messageType!.replaceAll('-', ' ');
    created = json['created'];
    deliveryMessage = message!.split(orderId!)[0];
    deliveryMessage = '$deliveryMessage$orderId'.trim();
    productName = message!.split(orderId!)[1].trim();
    productName =
        '${productName![0].toUpperCase()}${productName!.substring(1)}';
  }

  WCFMNotification.fromWooJson(Map json) {
    iD = json['id'];
    message = json['message'];
    orderId = json['order_id'];
    created = json['created'];
    productName = '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ID'] = iD;
    data['message'] = message;
    data['message_type'] = messageType;
    data['created'] = created;
    return data;
  }
}
