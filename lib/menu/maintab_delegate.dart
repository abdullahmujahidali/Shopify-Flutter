import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef TabKey = GlobalKey<NavigatorState>? Function();
typedef TabName = String? Function();

class MainTabControlDelegate {
  int? index;
  late Function(String? nameTab, {bool allowPush}) changeTab;
  late Function(int index) tabAnimateTo;
  late TabKey tabKey;
  late TabName currentTabName;

  static MainTabControlDelegate? _instance;

  static MainTabControlDelegate getInstance() {
    return _instance ??= MainTabControlDelegate._();
  }

  MainTabControlDelegate._();
}
