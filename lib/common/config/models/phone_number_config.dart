import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    show PhoneInputSelectorType;
export 'package:intl_phone_number_input/intl_phone_number_input.dart'
    show PhoneInputSelectorType;

class PhoneNumberConfig {
  final bool enablePhoneNumberValidation;
  final String countryCodeDefault;
  final String dialCodeDefault;
  final bool useInternationalFormat;
  final bool showCountryFlag;
  final List<String> customCountryList;
  final bool formatInput;
  final PhoneInputSelectorType selectorType;
  final bool selectorFlagAsPrefixIcon;

  PhoneNumberConfig({
    this.enablePhoneNumberValidation = false,
    this.countryCodeDefault = 'VN',
    this.dialCodeDefault = '+84',
    this.useInternationalFormat = true,
    this.showCountryFlag = true,
    this.customCountryList = const [],
    this.formatInput = false,
    this.selectorType = PhoneInputSelectorType.BOTTOM_SHEET,
    this.selectorFlagAsPrefixIcon = true,
  });

  factory PhoneNumberConfig.fromJson(Map json) {
    return PhoneNumberConfig(
      enablePhoneNumberValidation: json['enable'] ?? false,
      countryCodeDefault: json['countryCodeDefault'] ?? 'VN',
      dialCodeDefault: json['dialCodeDefault'] ?? '+84',
      useInternationalFormat: json['useInternationalFormat'] ?? true,
      showCountryFlag: json['showCountryFlag'] ?? true,
      customCountryList: json['customCountryList'] is List
          ? <String>[...json['customCountryList']]
          : [],
      formatInput: json['formatInput'] ?? false,
      selectorType: '${json['selectorType']}'.toPhoneInputSelectorType(),
      selectorFlagAsPrefixIcon: json['selectorFlagAsPrefixIcon'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['enable'] = enablePhoneNumberValidation;
    data['countryCodeDefault'] = countryCodeDefault;
    data['dialCodeDefault'] = dialCodeDefault;
    data['useInternationalFormat'] = useInternationalFormat;
    data['showCountryFlag'] = showCountryFlag;
    data['customCountryList'] = customCountryList;
    data['formatInput'] = formatInput;
    data['selectorType'] = selectorType.name;
    data['selectorFlagAsPrefixIcon'] = selectorFlagAsPrefixIcon;
    return data;
  }

  PhoneNumberConfig copyWith({
    bool? enablePhoneNumberValidation,
    String? countryCodeDefault,
    String? dialCodeDefault,
    bool? useInternationalFormat,
    bool? showCountryFlag,
    List<String>? customCountryList,
    bool? formatInput,
    PhoneInputSelectorType? selectorType,
    bool? selectorFlagAsPrefixIcon,
  }) {
    return PhoneNumberConfig(
      enablePhoneNumberValidation:
          enablePhoneNumberValidation ?? this.enablePhoneNumberValidation,
      countryCodeDefault: countryCodeDefault ?? this.countryCodeDefault,
      dialCodeDefault: dialCodeDefault ?? this.dialCodeDefault,
      useInternationalFormat:
          useInternationalFormat ?? this.useInternationalFormat,
      showCountryFlag: showCountryFlag ?? this.showCountryFlag,
      customCountryList: List<String>.from(
        customCountryList ?? this.customCountryList,
      ),
      formatInput: formatInput ?? this.formatInput,
      selectorType: selectorType ?? this.selectorType,
      selectorFlagAsPrefixIcon:
          selectorFlagAsPrefixIcon ?? this.selectorFlagAsPrefixIcon,
    );
  }
}

extension on String {
  PhoneInputSelectorType toPhoneInputSelectorType() {
    switch (this) {
      case 'DIALOG':
        return PhoneInputSelectorType.DIALOG;
      case 'DROPDOWN':
        return PhoneInputSelectorType.DROPDOWN;
      case 'BOTTOM_SHEET':
      default:
        return PhoneInputSelectorType.BOTTOM_SHEET;
    }
  }
}
