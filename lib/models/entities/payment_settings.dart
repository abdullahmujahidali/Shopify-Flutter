class PaymentSettings {
  /// https://shopify.dev/tutorials/create-a-checkout-with-storefront-api
  String? vaultId; // apply when checkout credit card

  String? cardVaultUrl;
  List<String>? acceptedCardBrands;
  String? countryCode;
  String? currencyCode;

  PaymentSettings(
      {this.cardVaultUrl,
      this.acceptedCardBrands,
      this.countryCode,
      this.currencyCode});

  Map<String, dynamic> toJson() {
    return {
      'cardVaultUrl': cardVaultUrl,
      'acceptedCardBrands': acceptedCardBrands,
      'countryCode': countryCode,
      'enabled': currencyCode
    };
  }

  PaymentSettings.fromShopifyJson(Map parsedJson) {
    cardVaultUrl = parsedJson['cardVaultUrl'];
    acceptedCardBrands = parsedJson['acceptedCardBrands'];
    countryCode = parsedJson['countryCode'];
    currencyCode = parsedJson['currencyCode'];
  }

  PaymentSettings.fromVaultIdShopifyJson(Map parsedJson) {
    vaultId = parsedJson['vaultId'];
  }
}
