class Currency {
  final String symbol;
  final int decimalDigits;
  final String currencyDisplay;
  final String currencyCode;
  final int smallestUnitRate;
  final bool symbolBeforeTheNumber;

  Currency({
    required this.symbol,
    this.decimalDigits = 0,
    required this.currencyDisplay,
    required this.currencyCode,
    required this.smallestUnitRate,
    this.symbolBeforeTheNumber = true,
  });

  factory Currency.fromJson(Map json) {
    return Currency(
      symbol: json['symbol'] ?? '\$',
      decimalDigits: json['decimalDigits'] ?? 2,
      currencyDisplay: json['currency'] ?? 'USD',
      currencyCode: (json['currencyCode'] ?? 'USD').toUpperCase(),
      smallestUnitRate: json['smallestUnitRate'] ?? 1,
      symbolBeforeTheNumber: json['symbolBeforeTheNumber'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['decimalDigits'] = decimalDigits;
    data['symbolBeforeTheNumber'] = symbolBeforeTheNumber;
    data['currency'] = currencyDisplay;
    data['currencyCode'] = currencyCode;
    data['smallestUnitRate'] = smallestUnitRate;
    return data;
  }
}
