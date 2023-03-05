part of '../../boxes.dart';

extension GeneralCacheExtension on CacheBox {
  Map<String, dynamic>? getInstagramCache(String path) {
    final key = '${BoxKeys.instagramCacheKeyPrefix}$path';
    return box.get(
      key,
    );
  }

  Future<void> setInstagramCache(
    String path,
    Map<String, dynamic>? data,
  ) async {
    final key = '${BoxKeys.instagramCacheKeyPrefix}$path';
    if (data == null) {
      return box.delete(key);
    }
    return box.put(key, data);
  }
}
