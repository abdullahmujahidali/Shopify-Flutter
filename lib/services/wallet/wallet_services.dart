import '../../models/entities/transaction.dart';
import '../../models/entities/transfer_form.dart';
import '../../models/index.dart';
import '../base_services.dart';

abstract class WalletServices {
  Future<double> getBalance({required String token});

  Future<PagingResponse<Transaction>> getTransactions({
    required dynamic page,
    required String token,
  });

  Future<void> processPayment({
    required String orderId,
    String? token,
  });

  Future<void> partialPayment({
    required String orderId,
    String? token,
  });

  Future<Product?> checkRecharge({required int amount});

  Future<User> checkEmailTransfer({
    required String email,
    required String token,
  });

  Future<bool> transfer({
    required String token,
    required TransferForm transferForm,
  });
}
