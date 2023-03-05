import '../index.dart';
import 'wallet_services.dart';

class TeraWalletServiceLocator {
  static void setup(String domain) {
    injector.registerLazySingleton<WalletServices>(
        () => TeraWalletServices(domain: domain));
  }
}
