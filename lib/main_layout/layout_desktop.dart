import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inspireui/icons/constants.dart';

import '../widgets/web_layout/appbar_web.dart';

class LayoutDesktop extends StatefulWidget {
  final Widget widget;

  const LayoutDesktop({Key? key, required this.widget}) : super(key: key);

  @override
  State<LayoutDesktop> createState() => _LayoutDesktopState();
}

class _LayoutDesktopState extends State<LayoutDesktop> {
  double heightAppbar = kHeightAppBarWeb;

  ValueNotifier<bool> enbaleAppbar = ValueNotifier<bool>(true);

  ValueNotifier<bool> hideAppBar = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: enbaleAppbar,
      builder: (_, enable, __) {
        return Stack(
          children: [
            Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 300),
                  child: Container(height: heightAppbar),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: kLimitWidthScreen,
                    ),
                    child: NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {
                        final direction = notification.direction;
                        if (direction == ScrollDirection.reverse) {
                          enbaleAppbar.value = false;
                          heightAppbar = 0;
                        } else if (direction == ScrollDirection.forward) {
                          enbaleAppbar.value = true;
                          heightAppbar = kHeightAppBarWeb;
                        }
                        return true;
                      },
                      child: widget.widget,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: enable ? Offset.zero : const Offset(0, -1),
              child: SizedBox(
                height: heightAppbar,
                child: const AppBarWeb(isSliver: false),
              ),
            ),
          ],
        );
      },
    );
  }
}
