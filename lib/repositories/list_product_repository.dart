import '../../../models/entities/paging_response.dart';
import '../../../services/paging/paging_repository.dart';
import '../models/entities/product.dart';

class ListProductRepository extends PagingRepository<Product> {
  ListProductRepository({
    required String categoryId,
    required int limit,
  })  : _categoryId = categoryId,
        _limit = limit;

  final String _categoryId;
  final int _limit;

  @override
  Future<PagingResponse<Product>> Function(dynamic) get requestApi =>
      (page) => service.api.getProductsByCategoryId(
            _categoryId,
            page: page,
            limit: _limit,
          );
}
