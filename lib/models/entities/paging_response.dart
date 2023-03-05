class PagingResponse<T> {
  final List<T>? data;
  final dynamic cursor;

  const PagingResponse({
    this.data,
    this.cursor,
  });
}
