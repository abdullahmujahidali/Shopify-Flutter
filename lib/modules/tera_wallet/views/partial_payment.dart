import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools/price_tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, CartModel, UserModel;
import '../../../models/tera_wallet/index.dart';
import 'widgets/warning_currency.dart';

const kAutoDeductBalanceForPartial = true;

class PayPartialPayment extends StatefulWidget {
  const PayPartialPayment({Key? key}) : super(key: key);

  @override
  State<PayPartialPayment> createState() => _PayPartialPaymentState();
}

class _PayPartialPaymentState extends State<PayPartialPayment> {
  bool isChecked = false;

  WalletModel get walletModel =>
      Provider.of<WalletModel>(context, listen: false);

  CartModel get cartModel => Provider.of<CartModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        cartModel.setWalletAmount(0.0);
        walletModel.getBalance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context).user;
    if (user == null || user.cookie == null || !kAutoDeductBalanceForPartial) {
      return const SizedBox();
    }

    final cartModel = Provider.of<CartModel>(context, listen: false);

    final currencyCode =
        Provider.of<AppModel>(context, listen: false).currencyCode;
    final defaultCurrency = kAdvanceConfig.defaultCurrency?.currencyCode;
    final disablePayment = defaultCurrency.toString().toLowerCase() !=
        currencyCode.toString().toLowerCase();

    return Consumer<WalletModel>(
      builder: (context, value, child) {
        final total = (cartModel.getTotal() ?? 0) + cartModel.walletAmount;
        if (value.balance == 0.0 ||
            cartModel.isWalletCart() ||
            (value.balance >= total && cartModel.walletAmount == 0.0)) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Row(children: [
                Checkbox(
                  value: isChecked,
                  onChanged: disablePayment
                      ? null
                      : (bool? val) {
                          setState(() {
                            isChecked = val!;
                            cartModel.setWalletAmount(
                                val == true ? value.balance : 0.0);
                          });
                        },
                ),
                Text(
                  S.of(context).payByWallet,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ]),
              if (disablePayment)
                WarningCurrency(defaultCurrency: defaultCurrency ?? ''),
            ],
          ),
        );
      },
    );
  }
}

class CheckoutWalletInfo extends StatelessWidget {
  const CheckoutWalletInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;
    final currency = Provider.of<AppModel>(context, listen: false).currency;

    return Consumer<CartModel>(builder: (context, model, child) {
      final walletAmount = model.walletAmount;
      if (walletAmount > 0 && kAutoDeductBalanceForPartial) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                S.of(context).viaWallet,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                '-${PriceTools.getCurrencyFormatted(walletAmount, currencyRate, currency: currency)!}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
              )
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}
