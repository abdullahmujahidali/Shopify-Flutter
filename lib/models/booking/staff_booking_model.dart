class StaffBookingModel {
  int? id;
  String? displayName;
  String? email;
  String? username;

  StaffBookingModel({
    this.id,
    this.displayName,
    this.email,
    this.username,
  });

  StaffBookingModel.fromJson(Map json) {
    id = json['id'] ?? '' as int?;
    displayName = json['displayname'] ?? '';
    email = json['email'] ?? '';
    username = json['username'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'username': username
    };
  }
}

class ProductBooking {
  int? id;
  String? name;
  String? staffCost;
  String? staffQty;
  String? price;

  ProductBooking.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    staffCost = json['staff_cost'];
    staffQty = json['staff_qty'];
    price = json['price'];
  }
}
