import 'package:flutter/cupertino.dart';

import '../route.dart';

mixin DigitsMobileLoginServiceMixin {
  dynamic getDigitsMobileLoginRoutesWithSettings(RouteSettings settings) {
    return DigitsMobileLoginRoute.getRoutesWithSettings(settings);
  }
}
