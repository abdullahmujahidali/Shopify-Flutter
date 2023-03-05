import '../../services/paging/paging_with_user_repository.dart';
import '../entities/transaction.dart';
import '../paging_data_provider.dart';

class WalletTransactionModel extends PagingDataProvider<Transaction> {
  WalletTransactionModel(
      PagingWithArgumentRepository<Transaction, String> repository)
      : super(dataRepo: repository);
}
