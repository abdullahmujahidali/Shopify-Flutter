import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

enum DeliveryStatus {
  pending,
  delivered,
  unknown,
}

extension DeliveryStatusExtension on DeliveryStatus {
  Color displayColor(context) {
    switch (this) {
      case DeliveryStatus.pending:
        return Theme.of(context).primaryColor;
      default:
        return Theme.of(context).splashColor;
    }
  }

  String getTranslation(context) {
    switch (this) {
      case DeliveryStatus.delivered:
        return S.of(context).delivered;
      default:
        return S.of(context).pending;
    }
  }
}
