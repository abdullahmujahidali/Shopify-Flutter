import 'package:country_pickers/country_pickers.dart';

import 'country_state.dart';

class Country {
  String? id;
  String? code;
  String? name;
  String? icon;
  String? idCountry;
  List<CountryState>? states = [];

  Country({this.id, this.name, this.states});

  Country.fromConfig(this.id, this.name, this.icon, List states) {
    code = id;
    name = name ?? CountryPickerUtils.getCountryByIsoCode(id!).name;
    for (var item in states) {
      states.add(CountryState.fromConfig(item));
    }
  }

  Country.fromMagentoJson(Map parsedJson) {
    id = parsedJson['id'];
    code = parsedJson['id'];
    name = parsedJson['full_name_english'] ?? parsedJson['full_name_locale'];
    final regions = parsedJson['available_regions'];
    if (regions != null) {
      for (var item in regions) {
        states!.add(CountryState.fromMagentoJson(item));
      }
    }
  }

  Country.fromOpencartJson(Map parsedJson) {
    id = parsedJson['country_id'];
    code = parsedJson['iso_code_2'];
    name = parsedJson['name'];
    states = [];
  }

  Country.fromPrestashop(Map parsedJson) {
    id = parsedJson['iso_code'];
    name = parsedJson['name'];
    code = parsedJson['iso_code'];
    idCountry = parsedJson['id'].toString();
  }

  Country.fromWooJson(Map parsedJson) {
    id = parsedJson['code'];
    code = parsedJson['code'];
    name = parsedJson['name'];
    states = [];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'states': states};
  }

  Country.fromLocalJson(Map json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
      states = json['states'];
    } catch (_) {}
  }
}

class ListCountry {
  List<Country>? list = [];

  ListCountry({this.list});

  ListCountry.fromMagentoJson(List? json) {
    if (json != null) {
      for (var item in json) {
        if (item['full_name_locale'] != null &&
            item['full_name_english'] != null &&
            item['id'] != null) {
          list!.add(Country.fromMagentoJson(item));
        }
      }
    }
  }

  ListCountry.fromOpencartJson(List? json) {
    if (json != null) {
      for (var item in json) {
        if (item['status'] == '1') {
          list!.add(Country.fromOpencartJson(item));
        }
      }
    }
  }

  ListCountry.fromWooJson(List json) {
    for (var item in json) {
      list!.add(Country.fromWooJson(item));
    }
  }
}
