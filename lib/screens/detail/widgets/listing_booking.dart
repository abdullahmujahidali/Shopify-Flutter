import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Product;
import '../../../services/service_config.dart';

class ListingBooking extends StatefulWidget {
  final Product? product;

  const ListingBooking(this.product);

  @override
  State<ListingBooking> createState() => _StateProductBooking();
}

class _StateProductBooking extends State<ListingBooking> {
  String? durationUnit;
  int? duration;
  int? minDuration;
  int? maxDuration;
  DateTime? minDate;
  late DateTime maxDate;
  DateTime? bookingDate;
  String? bookingDuration;
  String? price;

  @override
  void initState() {
    super.initState();
    getBookingData();
  }

  DateTime supportDate(String? unit, int? value) {
    var now = DateTime.now();
    var milliSecond = now.millisecondsSinceEpoch;
    Duration duration;
    switch (unit) {
      case 'day':
        {
          duration = Duration(days: value!);
          break;
        }
      case 'month':
        {
          duration = Duration(days: value! * 30);
          break;
        }
      case 'year':
        {
          duration = Duration(days: value! * 30 * 12);
          break;
        }
      default:
        duration = Duration(days: value!);
    }
    return DateTime.fromMillisecondsSinceEpoch(
        milliSecond + duration.inMilliseconds);
  }

  Future<void> getBookingData() async {
    var response = await httpGet(
        '${ServerConfig().url}/wp-json/wc-bookings/v1/products/${widget.product!.id}'
            .toUri()!);
    var body = jsonDecode(response.body);
    setState(() {
      durationUnit = body['duration_unit'];
      duration = body['duration'];
      minDuration = body['min_duration'];
      maxDuration = body['max_duration'];
      minDate = supportDate(body['min_date_unit'], body['min_date_value']);
      bookingDate = supportDate(body['min_date_unit'], body['min_date_value']);
      maxDate = supportDate(body['max_date_unit'], body['max_date_value']);
    });
  }

  Future<void> datePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: minDate!,
        firstDate: minDate!,
        lastDate: maxDate);
    if (date != null && date != bookingDate) {
      setState(() {
        bookingDate = date;
      });
    }
    await checkField();
  }

  Future<bool> checkField() async {
    var response = await httpPost(
        '${ServerConfig().url}/wp-admin/admin-ajax.php'.toUri()!,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'action': 'wc_bookings_calculate_costs',
          'form':
              'wc_bookings_field_duration=$bookingDuration&wc_bookings_field_start_date_month=${bookingDate!.month}&wc_bookings_field_start_date_day=${bookingDate!.day}&wc_bookings_field_start_date_year=${bookingDate!.year}&add-to-cart=${widget.product!.id}'
        });
    var body = jsonDecode(response.body);
    setState(() {
      price = body['html'];
    });
//    if (body['result'] == 'SUCCESS') setState(() {
//      price = body['html'];
//    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (minDate == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).dateBooking,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: datePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(2)),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              bookingDate.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).duration,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 2,
                  ),
                  Expanded(
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(2)),
                      child: TextField(
                        onSubmitted: (text) {
                          setState(() {
                            bookingDuration = text;
                          });
                          checkField();
                        },
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(price ?? '')
      ],
    );
  }
}
