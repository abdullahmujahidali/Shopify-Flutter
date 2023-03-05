import 'package:quiver/strings.dart';

class Menu {
  String? name;
  String? price;
  String? description;
  bool? bookable;

  Menu.fromJson(Map json) {
    name = json['name'];
    price = isNotBlank(json['price']) ? json['price'] : '0';
    bookable = json['bookable'] == 'on';
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'bookable': bookable,
      'description': description,
    };
  }
}
