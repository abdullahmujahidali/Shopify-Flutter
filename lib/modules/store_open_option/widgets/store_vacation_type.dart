import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../models/app_model.dart';
import '../../../models/entities/vacation_settings.dart';

class StoreVacationType extends StatefulWidget {
  final VacationOption option;
  final onCallBack;
  final DateTime? startDate;
  final DateTime? endDate;

  const StoreVacationType(
      {Key? key,
      required this.option,
      required this.onCallBack,
      this.startDate,
      this.endDate})
      : super(key: key);

  @override
  State<StoreVacationType> createState() => _StoreVacationTypeState();
}

class _StoreVacationTypeState extends State<StoreVacationType> {
  var _option;
  final _options = VacationOption.values;
  void _updateDate(List<DateTime> dates) {
    widget.onCallBack(dates);
  }

  @override
  void initState() {
    _option = widget.option;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.w500, fontFamily: 'Roboto');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).vacationType,
                style: titleTheme,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: DropdownButton<VacationOption>(
                value: _option,
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                onChanged: (val) {
                  _option = val!;
                  setState(() {});
                  widget.onCallBack(_option);
                },
                underline: const SizedBox(),
                items: List.generate(_options.length, (index) {
                  return DropdownMenuItem(
                    value: _options[index],
                    child: Center(
                        child: Text(
                      _options[index].getTranslation(context),
                      style: Theme.of(context).textTheme.bodySmall,
                    )),
                  );
                }),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        if (_option == VacationOption.dateWise) ...[
          Text(
            S.of(context).selectDates,
            style: titleTheme,
          ),
          const SizedBox(
            height: 15.0,
          ),
          VacationCalendar(
            onFinish: _updateDate,
            startDate: widget.startDate,
            endDate: widget.endDate,
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ],
    );
  }
}

class VacationCalendar extends StatefulWidget {
  final Function(List<DateTime> dates) onFinish;
  final DateTime? startDate;
  final DateTime? endDate;
  const VacationCalendar(
      {Key? key, required this.onFinish, this.startDate, this.endDate})
      : super(key: key);

  @override
  State<VacationCalendar> createState() => _VacationCalendarState();
}

class _VacationCalendarState extends State<VacationCalendar> {
  final List<DateTime> _list = [];

  final DateTime _currentDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  DateTime? _firstDate;
  DateTime? _lastDate;

  bool _isShowingMessage = false;

  bool isToday(DateTime date) {
    if (date.day == _currentDate.day &&
        date.month == _currentDate.month &&
        date.year == _currentDate.year) {
      return true;
    }
    return false;
  }

  void _showMessage(String message) async {
    /// Avoid showing multiple messages
    if (_isShowingMessage) {
      return;
    }
    _isShowingMessage = true;
    await ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ))
        .closed;
    _isShowingMessage = false;
  }

  void _updateDate(DateTime date) {
    if (date.isBefore(_currentDate) && !isToday(date)) {
      _showMessage(S.of(context).cantPickDateInThePast);
      return;
    }
    if (_firstDate == null) {
      _firstDate = date;
      setState(() {});
      return;
    }
    if (date.isBefore(_firstDate!)) {
      _showMessage(S.of(context).endDateCantBeAfterFirstDate);
      return;
    }
    _lastDate = date;
    _list.clear();
    _list.addAll(getDaysInBetween(_firstDate!, _lastDate!));
    setState(() {});
    widget.onFinish(_list);
  }

  void _reset() {
    _firstDate = null;
    _lastDate = null;
    _list.clear();
    setState(() {});
    widget.onFinish([]);
  }

  @override
  void initState() {
    if (widget.startDate != null && widget.endDate != null) {
      _firstDate = widget.startDate!;
      _lastDate = widget.endDate!;
      _list.addAll(getDaysInBetween(_firstDate!, _lastDate!));
    }
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
                  .titleLarge!
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
          height: 5.0,
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
            pageScrollPhysics: const NeverScrollableScrollPhysics(),
            customGridViewPhysics: const NeverScrollableScrollPhysics(),
            height: 300.0,
            targetDateTime: _targetDateTime,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: true,
            todayButtonColor: Colors.transparent,
            todayBorderColor: Colors.transparent,
            selectedDayButtonColor: Colors.transparent,
            prevMonthDayBorderColor: Colors.transparent,
            selectedDayBorderColor: Colors.transparent,
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
              if ((_firstDate != null && _firstDate == day) ||
                  (_lastDate != null && _lastDate == day)) {
                return Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Center(
                      child: Text('${day.day}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              }
              if (_list.contains(day)) {
                return Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text('${day.day}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              }
              if (day.weekday == DateTime.saturday ||
                  day.weekday == DateTime.sunday) {
                if (day.isAfter(_currentDate)) {
                  return Center(
                    child: Text('${day.day}',
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600)),
                  );
                }
                return Center(
                  child: Text('${day.day}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent.withOpacity(0.5))),
                );
              }

              if (day.isBefore(_currentDate) && day.day != _currentDate.day) {
                return Center(
                  child: Text('${day.day}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.7))),
                );
              }
              return Center(
                child: Text('${day.day}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600)),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child:
                TextButton(onPressed: _reset, child: Text(S.of(context).reset)),
          ),
        ),
      ],
    );
  }
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  var days = <DateTime>[];
  for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(DateTime(startDate.year, startDate.month, startDate.day + i));
  }
  return days;
}
