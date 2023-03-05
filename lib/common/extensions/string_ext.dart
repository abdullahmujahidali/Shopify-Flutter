extension StringExtension on String {
  String get paramSymbol {
    if (contains('?')) {
      return '&';
    }
    return '?';
  }
}
