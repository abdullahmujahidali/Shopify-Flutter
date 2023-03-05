import '../../../models/entities/index.dart' show Order;
import '../../../models/paging_data_provider.dart';
import '../../../services/paging/paging_with_user_repository.dart';

class ListOrderHistoryModel extends PagingDataProvider<Order> {
  ListOrderHistoryModel({required PagingWithUserRepository repository})
      : super(dataRepo: repository);
}
