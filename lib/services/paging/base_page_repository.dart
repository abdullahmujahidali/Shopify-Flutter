import '../index.dart' show ServerConfig, ConfigType, Services;

abstract class BasePageRepository<T> {
  final service = Services();

  BasePageRepository() {
    initCursor();
  }

  Future<List<T?>?> getData();

  dynamic cursor;

  bool hasNext = true;

  void refresh() {
    hasNext = true;
    cursor = null;
    initCursor();
  }

  /// Shopify and Notion, the cursor is String, the rest is int
  /// Shopify framework will return cursor
  /// The order framework will not and must to compute page number to call
  bool get cursorIsString => [
        ConfigType.shopify,
        ConfigType.notion,
      ].contains(ServerConfig().type);

  void initCursor() {
    if (!cursorIsString) {
      cursor = 1;
    }
  }

  void updateCursor(dynamic newCursor) {
    if (!cursorIsString) {
      cursor++;
      return;
    }
    cursor = newCursor;
  }

// T parseJson(Map<String, dynamic> json);

  Future<void> cancelCompleter() async{}
}
