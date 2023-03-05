class Tax {
  String? id;
  String? title;
  double? amount;

  Tax.fromJson(Map parsedJson) {
    title = parsedJson['label'];
    amount = double.parse('${(parsedJson['value'] ?? 0.0)}');
  }

  Tax.fromMagentoJson(Map parsedJson, double subtotal) {
    title = parsedJson['code'];
    amount = double.parse('${(parsedJson['rate'] ?? 0.0)}') * subtotal / 100;
  }
}
