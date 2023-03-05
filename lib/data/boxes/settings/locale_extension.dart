part of '../../boxes.dart';

extension LocaleSettings on SettingsBox {
  String? get languageCode {
    return box.get(
      BoxKeys.languageCode,
    );
  }

  set languageCode(String? value) {
    if (value == null) {
      box.delete(BoxKeys.languageCode);
      return;
    }
    box.put(BoxKeys.languageCode, value);
  }

  String? get currencyCode {
    return box.get(
      BoxKeys.currencyCode,
    );
  }

  set currencyCode(String? value) {
    if (value == null) {
      box.delete(BoxKeys.currencyCode);
      return;
    }
    box.put(BoxKeys.currencyCode, value);
  }

  String? get currency {
    return box.get(
      BoxKeys.currency,
    );
  }

  set currency(String? value) {
    if (value == null) {
      box.delete(BoxKeys.currency);
      return;
    }
    box.put(BoxKeys.currency, value);
  }

  String? get countryCode {
    return box.get(
      BoxKeys.countryCode,
    );
  }

  set countryCode(String? value) {
    if (value == null) {
      box.delete(BoxKeys.countryCode);
      return;
    }
    box.put(BoxKeys.countryCode, value);
  }

  List get countries {
    return box.get(
      BoxKeys.countries,
      defaultValue: [],
    );
  }

  set countries(List value) {
    box.put(BoxKeys.countries, value);
  }
}
