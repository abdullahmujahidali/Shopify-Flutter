import 'dart:async';

import 'package:async/async.dart';

import '../base_services.dart';
import 'base_page_repository.dart';

/// * [T] is type of the data
abstract class PagingRepository<T> extends BasePageRepository<T?> {
  Future<PagingResponse<T>>? Function(dynamic) get requestApi;
  CancelableCompleter<PagingResponse<T>>? _completer;

  @override
  Future<List<T?>?> getData() async {
    if (!hasNext) return <T>[];
    _completer = CancelableCompleter();
    _completer?.complete(requestApi(cursor)!);
    final response = await _completer?.operation.valueOrCancellation();
    if (_completer?.isCanceled ?? false) {
      return [];
    }
    // ignore: unnecessary_null_comparison
    if (response == null) return <T>[];

    var data = response.data;

    updateCursor(response.cursor);

    if (data?.isEmpty ?? true) {
      hasNext = false;
      return <T>[];
    }

    return data;
  }

  @override
  Future<void> cancelCompleter() async {
    await _completer?.operation.cancel();
  }
}
