import '../../../common/constants.dart';

class ShopifyStorage {
  String? categoryId;
  String? search;
  String? cursor = '';
  bool? hasNextPage = true;

  void setShopifyStorage(cursorValue, cateId, nextPage, search) {
    cursor = cursorValue;
    hasNextPage = nextPage;
    categoryId = cateId;
    search = search;

    printLog('setCurrentCursor with hasNextPage $nextPage');
    printLog('setCurrentCursor with cursor $cursorValue');
  }

  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'categoryId': categoryId,
      'hasNextPage': hasNextPage,
      'search': search
    };
  }
}
