class Shipping {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postCode;
  String? country;
  String? state;
  String? phone;

  Shipping.fromJson(Map json) {
    try {
      firstName = json['first_name'];
      lastName = json['last_name'];
      company = json['company'];
      address1 = json['address_1'];
      address2 = json['address_2'];
      city = json['city'];
      postCode = json['postcode'];
      country = json['country'];
      state = json['state'];
      phone = json['phone'];
    } catch (_) {}
  }

  Shipping.fromMagentoJson(Map json) {
    try {
      firstName = json['firstname'];
      lastName = json['lastname'];
      company = json['company'];
      address1 = json['street']?.join(' ');
      city = json['city'];
      postCode = json['postcode'];
      country = json['country_id'];
      phone = json['telephone'];
      state = json['state'] ?? city;
    } catch (_) {}
  }
}

class Billing {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postCode;
  String? country;
  String? state;
  String? email;
  String? phone;

  Billing.fromJson(Map json) {
    try {
      firstName = json['first_name'];
      lastName = json['last_name'];
      company = json['company'];
      address1 = json['address_1'];
      address2 = json['address_2'];
      city = json['city'];
      postCode = json['postcode'];
      country = json['country'];
      state = json['state'];
      email = json['email'];
      phone = json['phone'];
    } catch (_) {}
  }

  Billing.fromMagentoJson(Map json) {
    try {
      firstName = json['firstname'];
      lastName = json['lastname'];
      company = json['company'];
      address1 = json['street']?.join(' ');
      city = json['city'];
      postCode = json['postcode'];
      country = json['country_id'];
      phone = json['telephone'];
      state = json['state'] ?? city;
    } catch (_) {}
  }

  Map toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'postcode': postCode,
      'country': country,
      'state': state,
      'email': email,
      'phone': phone,
    };
  }
}
