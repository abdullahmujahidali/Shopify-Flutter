import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/tera_wallet/wallet_model.dart';
import '../../models/tera_wallet/wallet_transfer_model.dart';
import 'views/index.dart';

class TeraWalletRoute {
  static dynamic getRoutesWithSettings(RouteSettings settings) {
    final routes = {
      RouteList.teraWalletTopUp: (context) => const TopUpScreen(),
      RouteList.myWallet: (BuildContext context) =>
          ChangeNotifierProvider.value(
            value: context.read<WalletModel>().walletTransactionModel,
            child: const MyWalletScreen(),
          ),
      RouteList.teraWalletTransfer: (context) {
        final arguments = settings.arguments;
        return ChangeNotifierProvider<WalletTransferModel>(
          create: (context) => WalletTransferModel(
            walletModel: context.read<WalletModel>(),
          ),
          builder: (context, snapshot) {
            if (arguments is TransferArguments) {
              return TransferScreen(email: arguments.email);
            }
            return const TransferScreen();
          },
        );
      },
      RouteList.teraWalletTransactions: (BuildContext context) =>
          ChangeNotifierProvider.value(
              value: context.read<WalletModel>().walletTransactionModel,
              builder: (context, snapshot) {
                return const TransactionScreen();
              }),
      RouteList.teraWalletTransactionDetail: (BuildContext context) {
        final arguments = settings.arguments;
        if (arguments is TransactionDetailArguments) {
          return TransactionDetailScreen(
            transaction: arguments.transaction,
          );
        }
        return errorPage('Transaction Detail error arguments');
      },
      RouteList.teraWalletTransferSuccess: (context) =>
          const TransferSuccessScreen(),
      RouteList.teraWalletTransferFail: (context) {
        final arguments = settings.arguments;
        if (arguments is TransferFailArguments) {
          return TransferFailScreen(
            errorMessage: arguments.errorMessage,
          );
        }
        return const TransferFailScreen(
          errorMessage: 'Something went wrong!',
        );
      },
    };
    return routes;
  }

  static Widget errorPage(String title) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(title),
        ),
      );
}
