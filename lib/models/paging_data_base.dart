import 'dart:collection';

import 'package:flutter/cupertino.dart';

abstract class PagingDataBase<T> extends ChangeNotifier {
  bool get isLoading;

  bool get isFirstLoad;

  bool get isLoadMore;

  bool get hasNext;

  UnmodifiableListView<T> get data;

  Future<void> getData();

  Future<void> refresh({bool autoGetData = true});
}
