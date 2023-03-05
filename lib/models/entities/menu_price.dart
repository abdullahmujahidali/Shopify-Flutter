import '../../common/constants.dart';

import 'menu.dart';

class ListingMenu {
  String? title;
  List<Menu> menu = [];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'menu': menu.map((e) => e.toJson()).toList(),
    };
  }

  ListingMenu.fromJson(Map json) {
    try {
      title = json['menu_title'] ?? '';
      List? elements = json['menu_elements'] is Map
          ? json['menu_elements'].values.toList()
          : json['menu_elements'];
      if (elements != null && elements.isNotEmpty) {
        for (var i = 0; i < elements.length; i++) {
          if (elements[i]['bookable'] == 'on') {
            var item = Menu.fromJson(elements[i]);
            if (item.bookable!) {
              menu.add(item);
            }
          }
        }
      }
    } catch (e) {
      printLog('ListingMenu.fromJson $e');
    }
  }
}
