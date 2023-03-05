import 'package:inspireui/inspireui.dart' show DateTimeUtils;

import 'staff_booking_model.dart';

class BookingModel {
  int? month;
  int? day;
  int? year;
  DateTime? timeStart;
  String? idProduct;
  String? idOrder;
  List<StaffBookingModel?>? staffs = [];

  BookingModel({
    this.month,
    this.day,
    this.year,
    this.timeStart,
    this.idProduct,
    this.idOrder,
    this.staffs,
  });

  bool get isEmpty =>
      month == null ||
      day == null ||
      year == null ||
      timeStart == null ||
      idProduct == null;

  void setDay(DateTime date) {
    month = date.month;
    year = date.year;
    day = date.day;
    timeStart = null;
  }

  void setHour(DateTime time) {
    timeStart = time;
  }

  bool get isAvaliableOrder => idOrder?.isNotEmpty ?? false;

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'day': day,
      'year': year,
      'timeStart': timeStart!.toIso8601String(),
      'idProduct': idProduct,
      'idOrder': idOrder,
      'staffs': (staffs?.isNotEmpty ?? false) && staffs![0] != null
          ? staffs?.map((e) => e!.toJson()).toList()
          : [],
    };
  }

  BookingModel.fromLocalJson(Map json) {
    month = json['month'];
    day = json['day'];
    year = json['year'];
    timeStart = DateTime.parse(json['timeStart']);
    idProduct = json['idProduct'];
    idOrder = json['idOrder'];
    var items = <StaffBookingModel?>[];
    if (json['staffs'] != null) {
      for (var item in json['staffs']) {
        items.add(StaffBookingModel.fromJson(item));
      }
    }
    staffs = items;
  }

  Map<String, dynamic> toJsonAPI() {
    final listStaff = <int?>[];
    if (staffs?.isNotEmpty ?? true) {
      for (var element in staffs!) {
        if (element != null) {
          listStaff.add(element.id);
        }
      }
    }

    return {
      'wc_appointments_field_start_date_month': '$month',
      'wc_appointments_field_start_date_day': '$day',
      'wc_appointments_field_start_date_year': '$year',
      'wc_appointments_field_start_date_time':
          DateTimeUtils.getTimeBooking(timeStart!),
      'wc_appointments_field_addons_duration': '0',
      'wc_appointments_field_addons_cost': '0',
      'product_id': idProduct,
      'order_id': idOrder,
      'staff_ids': listStaff,
    };
  }
}
