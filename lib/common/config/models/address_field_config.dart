import 'package:flutter/material.dart';

import '../../../modules/dynamic_layout/helper/helper.dart';

enum AddressFieldType {
  firstName(
    autofillHint: AutofillHints.givenName,
    keyboardType: TextInputType.name,
  ),
  lastName(
    autofillHint: AutofillHints.familyName,
    keyboardType: TextInputType.name,
  ),
  phoneNumber(
    autofillHint: AutofillHints.telephoneNumber,
    keyboardType: TextInputType.phone,
  ),
  email(
    autofillHint: AutofillHints.email,
    keyboardType: TextInputType.emailAddress,
  ),
  searchAddress,
  selectAddress,
  country(
    autofillHint: AutofillHints.countryName,
    keyboardType: TextInputType.streetAddress,
  ),
  state(
    autofillHint: AutofillHints.addressState,
    keyboardType: TextInputType.streetAddress,
  ),
  city(
    autofillHint: AutofillHints.addressCity,
    keyboardType: TextInputType.streetAddress,
  ),
  apartment(
    keyboardType: TextInputType.streetAddress,
  ),
  block(
    keyboardType: TextInputType.streetAddress,
  ),
  street(
    autofillHint: AutofillHints.fullStreetAddress,
    keyboardType: TextInputType.streetAddress,
  ),
  zipCode(
    autofillHint: AutofillHints.postalCode,
    keyboardType: TextInputType.number,
  ),
  // custom,
  unknown;

  final String? autofillHint;
  final TextInputType keyboardType;

  const AddressFieldType({
    this.autofillHint,
    this.keyboardType = TextInputType.text,
  });
}

class AddressFieldConfig {
  final AddressFieldType type;
  final bool visible;
  final int position;
  final bool editable;
  final bool required;
  final String defaultValue;

  AddressFieldConfig({
    required this.type,
    required this.visible,
    required this.position,
    required this.editable,
    required this.required,
    required this.defaultValue,
  });

  AddressFieldConfig copyWith({
    AddressFieldType? type,
    bool? visible,
    int? position,
    bool? editable,
    bool? required,
    String? defaultValue,
  }) {
    return AddressFieldConfig(
      type: type ?? this.type,
      visible: visible ?? this.visible,
      position: position ?? this.position,
      editable: editable ?? this.editable,
      required: required ?? this.required,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  Map<String, dynamic> toMap() {
    final result = {
      'type': type.name,
      'visible': visible,
      'position': position,
    };
    if (type != AddressFieldType.selectAddress &&
        type != AddressFieldType.searchAddress) {
      result.addAll(
        {
          'editable': editable,
          'required': required,
          'defaultValue': defaultValue,
        },
      );
    }
    return result;
  }

  factory AddressFieldConfig.fromMap(Map map) {
    return AddressFieldConfig(
      type: AddressFieldType.values.firstWhere(
        (type) => map['type'] == type.name,
        orElse: () => AddressFieldType.unknown,
      ),
      visible: map['visible'] != false,
      position: Helper.formatInt(map['position']) ?? 999,
      editable: map['editable'] != false,
      required: map['required'] == true,
      defaultValue: '${map['defaultValue'] ?? ''}',
    );
  }
}
