import 'package:json_annotation/json_annotation.dart';

import 'payment.dart';
import 'product.dart';
import 'shipping.dart';
import 'user.dart';

part 'order.g.dart';

@JsonSerializable()
class SerializerOrder {
  int? id;
  @JsonKey(name: 'created_at')
  String? createdAt;
  double? total;
  SerializerUser? user;
  SerializerShipping? shipping;
  SerializerPayment? payment;
  List<SerializerProduct>? products;
  SerializerOrder(
      {this.id,
      this.createdAt,
      this.total,
      this.user,
      this.shipping,
      this.payment,
      this.products});

  factory SerializerOrder.fromJson(Map<String, dynamic> json) =>
      _$SerializerOrderFromJson(json);

  Map<String, dynamic> toJson() => _$SerializerOrderToJson(this);

  @override
  String toString() =>
      'SerializerPayment { id: $id from user: ${user!.user!.username}';
}
