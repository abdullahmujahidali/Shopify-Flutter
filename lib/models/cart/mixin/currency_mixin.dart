import '../../../common/config.dart';
import '../../../data/boxes.dart';
import 'cart_mixin.dart';

mixin CurrencyMixin on CartMixin {
  String? getCurrency() {
    currencyCode = SettingsBox().currencyCode ??
        kAdvanceConfig.defaultCurrency?.currencyCode;
    return currencyCode;
  }

  void changeCurrency(value) {
    currencyCode = value;
  }

  void changeCurrencyRates(value) {
    currencyRates = value;
  }
}
