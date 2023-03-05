import '../models/entities/category.dart';

import '../models/entities/paging_response.dart';
import '../services/paging/paging_repository.dart';

class ListCategoryRepository extends PagingRepository<Category> {
  final String? _parentId;
  final int _limit;

  ListCategoryRepository({
    required String? parentId,
    required int limit,
  })  : _parentId = parentId,
        _limit = limit;

  @override
  Future<PagingResponse<Category>> Function(dynamic) get requestApi =>
      (page) => service.api.getSubCategories(
            page: page,
            limit: _limit,
            parentId: _parentId,
          );
}
