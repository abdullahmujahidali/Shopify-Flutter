import 'package:flutter/cupertino.dart';

class TextStyleModel with ChangeNotifier {
  double _contentTextSize = 15.0;

  double get contentTextSize => _contentTextSize;

  void adjustTextSize(double textSize) {
    _contentTextSize = textSize;
    notifyListeners();
  }
}
