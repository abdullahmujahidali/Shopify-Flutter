class OrderDeliveryDate {
  String? timeStamp;
  String? dateString;
  DateTime? dateTime;
  String? deliveryDate;

  OrderDeliveryDate(this.dateTime);

  OrderDeliveryDate.fromJson(json) {
    timeStamp = json['timestamp'].toString();
    dateString = json['date'];
    deliveryDate = json['delivery_date'];
    if (dateString != null) {
      dateTime = DateTime(
          int.parse(dateString!.split('-')[2]),
          int.parse(dateString!.split('-')[1]),
          int.parse(dateString!.split('-')[0]));
    }
  }
}
