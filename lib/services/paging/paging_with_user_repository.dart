import 'dart:async';

import '../../models/index.dart';
import '../base_services.dart';
import 'base_page_repository.dart';

abstract class PagingWithUserRepository<T> extends BasePageRepository<T?> {
  Future<PagingResponse<T>>? Function({
    required User user,
    required dynamic cursor,
  }) get requestApi;

  final User user;

  PagingWithUserRepository(this.user);

  @override
  Future<List<T?>?> getData() async {
    if (!hasNext) return <T>[];

    final response = await requestApi(
      cursor: cursor,
      user: user,
    );

    if (response == null) {
      return <T>[];
    }

    final data = response.data;

    updateCursor(response.cursor);

    if ((data?.isEmpty ?? true) || cursor == null) {
      hasNext = false;
      return <T>[];
    }

    return data;
    // return data.map((json) => parseJson(json)).toList();
  }
}

abstract class PagingWithArgumentRepository<T, R>
    extends BasePageRepository<T?> {
  Future<PagingResponse<T>>? Function({
    required R arguments,
    required dynamic cursor,
  }) get requestApi;

  final R arguments;

  PagingWithArgumentRepository(this.arguments);

  @override
  Future<List<T?>?> getData() async {
    if (!hasNext) return <T>[];

    final response = await requestApi(
      cursor: cursor,
      arguments: arguments,
    );

    // ignore: unnecessary_null_comparison
    if (response == null) return <T>[];

    final data = response.data;

    updateCursor(response.cursor);

    if ((data?.isEmpty ?? true) || cursor == null) {
      hasNext = false;
      return <T>[];
    }

    return data;
    // return data.map((json) => parseJson(json)).toList();
  }
}
