class ProductAddons {
  String? name;
  String? description;
  String? type;
  String? display;
  String? price;
  int? position;
  List<AddonsOption>? options;
  bool? required;
  Map<String, AddonsOption> defaultOptions = {};
  String? fieldName;

  ProductAddons({
    this.name,
    this.description,
    this.type,
    this.position,
    this.options,
    this.required = false,
  });

  bool get isHeadingType => type == 'heading';

  bool get isRadioButtonType =>
      type == 'multiple_choice' || type == 'radiobutton';

  bool get isCheckboxType => type == 'checkbox';

  bool get isTextType => isLongTextType || isShortTextType;

  bool get isShortTextType => type == 'custom_text';

  bool get isLongTextType => type == 'custom_textarea';

  bool get isCustomPriceType => type == 'custom_price';

  bool get isFileUploadType => type == 'file_upload';

  ProductAddons.fromJson(Map json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
    display = json['display'];
    price = '${json['price']}';
    position = json['position'];
    required = json['required'] == 1;
    fieldName = json['field_name'];
    if (json['options'] != null) {
      final List<dynamic> values = json['options'] ?? [];
      options = List<AddonsOption>.generate(
        values.length,
        (index) {
          final option = AddonsOption.fromJson(values[index]);
          option.parent = name;
          option.type = type;
          option.display = display;
          option.fieldName = fieldName;
          option.index = index + 1;
          if ((option.isDefault ?? false) && option.label != null) {
            defaultOptions[option.label!] = option;
          }
          return option;
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    data['display'] = display;
    data['price'] = price;
    data['position'] = position;
    data['field_name'] = fieldName;
    data['required'] = (required ?? false) ? 1 : 0;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddonsOption {
  String? parent;
  String? label;
  String? price;
  String? priceType;
  bool? isDefault;
  String? type;
  String? display;
  String? fieldName;
  int? index;

  bool get isFileUploadType => type == 'file_upload';

  bool get isTextType => isLongTextType || isShortTextType;

  bool get isShortTextType => type == 'custom_text';

  bool get isLongTextType => type == 'custom_textarea';

  bool get isFlatFee => priceType == 'flat_fee';

  bool get isCustomPriceType => type == 'custom_price';

  bool get isEnteredByUser => isTextType || isCustomPriceType || isFileUploadType;

  bool get isQuantityBased => priceType == 'quantity_based';

  AddonsOption({
    this.parent,
    this.type,
    this.display,
    this.label,
    this.price,
    this.priceType,
    this.isDefault = false,
    this.fieldName,
    this.index,
  });

  AddonsOption.copy(AddonsOption option) {
    parent = option.parent;
    label = option.label;
    priceType = option.priceType;
    price = option.price;
    type = option.type;
    display = option.display;
    isDefault = option.isDefault;
    fieldName = option.fieldName;
    index = option.index;
  }

  AddonsOption.fromJson(Map json) {
    parent = json['parent'];
    label = json['label'];
    priceType = json['price_type'];
    price = '${json['price']}';
    type = json['type'];
    display = json['display'];
    isDefault = json['default'] == '1';
    fieldName = json['field_name'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['parent'] = parent;
    data['label'] = label;
    data['price'] = price;
    data['price_type'] = priceType;
    data['type'] = type;
    data['display'] = display;
    data['default'] = (isDefault ?? false) ? '1' : '0';
    data['field_name'] = fieldName;
    data['index'] = index;
    return data;
  }
}
