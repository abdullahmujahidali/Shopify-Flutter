import '../../../models/entities/paging_response.dart';
import '../../../models/entities/transaction.dart';
import '../../../services/dependency_injection.dart';
import '../../../services/paging/paging_with_user_repository.dart';
import '../../../services/wallet/wallet_services.dart';

class TeraWalletTransactionRepository
    extends PagingWithArgumentRepository<Transaction, String> {
  final _teraServices = injector<WalletServices>();

  TeraWalletTransactionRepository(String token) : super(token);

  @override
  void initCursor() => cursor = 0;

  @override
  Future<PagingResponse<Transaction>>? Function({
    required String arguments,
    required dynamic cursor,
  }) get requestApi => ({cursor, required arguments}) =>
      _teraServices.getTransactions(page: cursor, token: arguments);
}
