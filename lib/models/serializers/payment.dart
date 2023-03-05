import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class SerializerPayment {
  int? id;
  String? title;
  String? description;

  SerializerPayment({this.id, this.title, this.description});

  factory SerializerPayment.fromJson(Map<String, dynamic> json) =>
      _$SerializerPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$SerializerPaymentToJson(this);

  @override
  String toString() => 'SerializerPayment { id: $id title $title}';
}
