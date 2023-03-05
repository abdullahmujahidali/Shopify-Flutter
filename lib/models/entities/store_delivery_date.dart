import 'package:intl/intl.dart';

class StoreDeliveryDate {
  late String storeId;
  late List<DateTime> deliveryDates;
  StoreDeliveryDate({
    required this.storeId,
    required String dateTime,
  }) {
    deliveryDates = _convertTimeStampToDateTime(dateTime);
  }

  String get displayDDate => _displayDate();

  @override
  String toString() =>
      'StoreDeliveryDate(storeId: $storeId, deliveryDate: $deliveryDates)';

  List<DateTime> _convertTimeStampToDateTime(String ts) {
    var listDateTime = <DateTime>[];
    if (ts.contains('|')) {
      var list = ts.split('|');
      for (var item in list) {
        listDateTime.add(DateTime.fromMillisecondsSinceEpoch(
            int.parse(item) * 1000,
            isUtc: true));
      }
      return listDateTime;
    }
    listDateTime.add(
        DateTime.fromMillisecondsSinceEpoch(int.parse(ts) * 1000, isUtc: true));
    return listDateTime;
  }

  String _displayDate() {
    var format = DateFormat('dd/MM/yyyy');

    /// The Delivery Dates never exceed more than 2 dates
    if (deliveryDates.length > 1) {
      final df = deliveryDates.first;
      final dl = deliveryDates.last;
      var displayDate = format.format(df);

      displayDate +=
          ' ${df.hour.toString().padLeft(2, '0')}:${df.minute.toString().padLeft(2, '0')} - ${dl.hour.toString().padLeft(2, '0')}:${dl.minute.toString().padLeft(2, '0')}';
      return displayDate;
    }
    return format.format(deliveryDates.first);
  }
}
