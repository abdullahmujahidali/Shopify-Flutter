import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../services/base_services.dart';
import '../services/service_config.dart';
import '../services/services.dart';
import 'paging_data_base.dart';

/// Like Paging data base, but not request pass repository
abstract class PagingDataModel<T> extends PagingDataBase<T> {
  PagingDataModel() {
    _initCursor();
  }

  BaseServices get api => Services().api;

  @override
  UnmodifiableListView<T> get data => UnmodifiableListView(_data ?? <T>[]);

  @override
  bool get isLoading => _isLoading;

  @override
  bool get isFirstLoad => _data == null;

  @override
  bool get isLoadMore => isLoading && (data.isNotEmpty);

  @override
  bool get hasNext => _hasNext;

  // @override
  // bool get isFirstPage => _cursor == null || _cursor == 1;

  List<T>? _data;

  bool _isLoading = false;
  bool _isDisposed = false;

  dynamic _cursor;

  bool _hasNext = true;

  @protected
  Future<PagingResponse<T>>? Function(dynamic) get requestApi;

  @override
  Future<void> getData() async {
    try {
      if (_isLoading) return;
      if (!hasNext) {
        _isLoading = true;
        _updateState();
        await Future.delayed(const Duration(milliseconds: 500), () {
          _isLoading = false;
        });
        _updateState();
        return;
      }
      _isLoading = true;
      _updateState();

      final apiData = await _getData();

      _data = [..._data ?? [], ...apiData as Iterable<T>? ?? []];
      await Future.delayed(const Duration(milliseconds: 300), () {
        _isLoading = false;
      });
      _updateState();
    } catch (e) {
      _isLoading = false;
    }
  }

  @override
  Future<void> refresh({bool autoGetData = true}) async {
    _refresh();
    _data = null;
    _updateState();
    if (autoGetData) {
      Future.delayed(const Duration(milliseconds: 300), getData);
    }
  }

  void _updateState() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  bool get _cursorIsString => [
        ConfigType.shopify,
        ConfigType.notion,
      ].contains(ServerConfig().type);

  void _initCursor() {
    if (!_cursorIsString) {
      _cursor = 1;
    }
  }

  void _refresh() {
    _hasNext = true;
    _cursor = null;
    _initCursor();
  }

  void _updateCursor(dynamic newCursor) {
    if (!_cursorIsString) {
      _cursor++;
      return;
    }
    _cursor = newCursor;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<List<T?>?> _getData() async {
    if (!hasNext) return <T>[];

    final response = await requestApi(_cursor)!;

    // ignore: unnecessary_null_comparison
    if (response == null) return <T>[];

    var data = response.data;

    _updateCursor(response.cursor);

    if (data?.isEmpty ?? true) {
      _hasNext = false;
      return <T>[];
    }

    return data;
  }
}
