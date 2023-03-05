import 'dart:convert';

class ListingSlots {
  List<List<dynamic>> timeSlots = [];

  ListingSlots.fromJson(slot) {
    if (slot != null && slot.isNotEmpty) {
      try {
        var json = slot is String
            ? jsonDecode(slot)
            : slot; // slot should be list or string
        for (var item in json) {
          var list = <dynamic>[];
          for (var timeSlot in item) {
            list.add(timeSlot.split('|')[0]);
          }
          timeSlots.add(list);
        }
      } catch (e) {
        return;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {'timeSlots': timeSlots};
  }
}
