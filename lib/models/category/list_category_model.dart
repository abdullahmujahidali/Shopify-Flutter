import '../../repositories/list_category_repository.dart';
import '../entities/category.dart';
import '../paging_data_provider.dart';

class ListCategoryModel extends PagingDataProvider<Category> {
  ListCategoryModel({
    String? parentId,
    int limit = 25,
  }) : super(
          dataRepo: ListCategoryRepository(
            parentId: parentId,
            limit: limit,
          ),
        );
}
