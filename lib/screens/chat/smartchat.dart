import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/config.dart' show kConfigChat;

import 'bottom_sheet_smart_chat.dart';
import 'fab_circle_smart_chat.dart';

class SmartChat extends StatelessWidget {
  final EdgeInsets? margin;
  final List<Map>? options;

  const SmartChat({
    this.margin,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    final version = kConfigChat['version'] ?? '2';

    if (version == '2') {
      return BottomSheetSmartChat(
        margin: margin,
        options: options,
      );
    }
    return FabCircleSmartChat(
      margin: margin,
      options: options,
    );
  }
}
