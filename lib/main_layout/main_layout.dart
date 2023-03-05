import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../modules/dynamic_layout/helper/helper.dart';
import 'layout_desktop.dart';

class MainLayout extends StatelessWidget {
  final Widget widget;

  const MainLayout({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = widget;
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    if (Layout.isDisplayDesktop(context) &&
        deviceType == DeviceScreenType.desktop) {
      body = LayoutDesktop(widget: widget);
    }

    return Overlay(
      key: ValueKey('screenType:$deviceType'),
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            return Material(child: body);
          },
        ),
      ],
    );
  }
}
