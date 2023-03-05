import 'package:flutter/material.dart';

class RefreshScrollPhysics extends BouncingScrollPhysics {
  const RefreshScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  RefreshScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return RefreshScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }
}
