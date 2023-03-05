import '../../models/entities/paging_response.dart';
import '../../models/entities/product.dart';
import '../../models/entities/transaction.dart';
import '../../models/entities/transfer_form.dart';
import '../../models/entities/user.dart';
import 'wallet_services.dart';

class WalletServicesImpl implements WalletServices {
  @override
  Future<double> getBalance({required String token}) async {
    return 0.0;
  }

  @override
  Future<PagingResponse<Transaction>> getTransactions(
      {required page, required token}) async {
    return const PagingResponse(data: [Transaction()]);
  }

  @override
  Future<void> processPayment({required String orderId, String? token}) async {}

  @override
  Future<void> partialPayment({required String orderId, String? token}) async {}

  @override
  Future<Product?> checkRecharge({required int amount}) async {
    return null;
  }

  @override
  Future<User> checkEmailTransfer(
      {required String email, required String token}) async {
    return User();
  }

  @override
  Future<bool> transfer({
    required String token,
    required TransferForm transferForm,
  }) async {
    return true;
  }
}
