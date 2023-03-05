import '../../repositories/list_product_repository.dart';
import '../entities/product.dart';
import '../paging_data_provider.dart';

class ListProductModel extends PagingDataProvider<Product> {
  ListProductModel({
    required String categoryId,
    int limit = 25,
  }) : super(
            dataRepo: ListProductRepository(
          categoryId: categoryId,
          limit: limit,
        ));
}
