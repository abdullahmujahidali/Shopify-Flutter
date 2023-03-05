import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/order_delivery_date.dart';
import '../../../models/index.dart';

class DeliveryCalendar extends StatefulWidget {
  final List<OrderDeliveryDate> dates;
  const DeliveryCalendar({Key? key, required this.dates}) : super(key: key);

  @override
  State<DeliveryCalendar> createState() => _DeliveryCalendarState();
}

class _DeliveryCalendarState extends State<DeliveryCalendar> {
  final List<DateTime> _list = [];

  DateTime _currentDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  void _getDates() {
    _currentDate = widget.dates.first.dateTime!;

    for (var element in widget.dates) {
      _list.add(element.dateTime!);
    }
    final cartModel = Provider.of<CartModel>(context, listen: false);
    cartModel.selectedDate = widget.dates.first;
  }

  void _updateDate(DateTime date) {
    if (_list.contains(date)) {
      _currentDate = date;
      var index =
          widget.dates.indexWhere((element) => element.dateTime == date);
      final cartModel = Provider.of<CartModel>(context, listen: false);
      if (index != -1) {
        cartModel.selectedDate = widget.dates[index];
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _getDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppModel>(context, listen: false);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 13.0,
            ),
            Text(
              _currentMonth,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700, fontFamily: 'Roboto'),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  _targetDateTime =
                      DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                  _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                });
              },
              child: Text(S.of(context).prev.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(
              width: 25.0,
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month + 1);
                    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                  });
                },
                child: Text(
                  S.of(context).next.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall,
                )),
            const SizedBox(
              width: 13.0,
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColorLight),
              borderRadius: BorderRadius.circular(9.0)),
          child: CalendarCarousel<Event>(
            locale: app.langCode,
            onDayPressed: (DateTime date, List<Event> events) {
              _updateDate(date);
            },
            weekendTextStyle: const TextStyle(
              color: Colors.redAccent,
            ),
            onCalendarChanged: (DateTime date) {
              setState(() {
                _targetDateTime = date;
                _currentMonth = DateFormat.yMMM().format(_targetDateTime);
              });
            },
            thisMonthDayBorderColor: Colors.transparent,
            weekFormat: false,
            showHeader: false,
            height: 300.0,
            targetDateTime: _targetDateTime,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: true,
            todayButtonColor: Colors.transparent,
            todayBorderColor: Colors.transparent,
            selectedDayButtonColor: Theme.of(context).primaryColor,
            prevMonthDayBorderColor: Colors.transparent,
            customDayBuilder: (
              bool isSelectable,
              int index,
              bool isSelectedDay,
              bool isToday,
              bool isPrevMonthDay,
              TextStyle textStyle,
              bool isNextMonthDay,
              bool isThisMonthDay,
              DateTime day,
            ) {
              if (day.weekday == DateTime.saturday ||
                  day.weekday == DateTime.sunday) {
                if (_list.contains(day)) {
                  return Center(
                    child: Text('${day.day}',
                        style: TextStyle(
                            color:
                                isSelectedDay ? Colors.white : Colors.redAccent,
                            fontWeight: isSelectedDay
                                ? FontWeight.bold
                                : FontWeight.w600)),
                  );
                }
                return Center(
                  child: Text('${day.day}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent.withOpacity(0.5))),
                );
              }

              if (!_list.contains(day) || isPrevMonthDay || isNextMonthDay) {
                return Center(
                  child: Text('${day.day}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.7))),
                );
              } else {
                return Center(
                  child: Text('${day.day}',
                      style: TextStyle(
                          color: isSelectedDay
                              ? Colors.white
                              : Theme.of(context).colorScheme.secondary,
                          fontWeight: isSelectedDay
                              ? FontWeight.bold
                              : FontWeight.normal)),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
