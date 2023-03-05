import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/transaction.dart';
import '../../../models/entities/user.dart';
import '../../../models/user_model.dart';
import '../helpers/wallet_helpers.dart';
import 'transfer_screen.dart';

const _borderRadius = 12.0;
const _iconSize = 40.0;
const _borderWidth = 0.5;

class TransactionDetailArguments {
  final Transaction transaction;

  const TransactionDetailArguments({
    required this.transaction,
  });
}

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  final Transaction transaction;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  Transaction get transaction => widget.transaction;

  User? get userCreateTransaction => transaction.userCreate;

  User get currentUser => Provider.of<UserModel>(context, listen: false).user!;

  bool get isMyself =>
      userCreateTransaction != null &&
      userCreateTransaction!.id == currentUser.id;

  @override
  Widget build(BuildContext context) {
    var icon = const Icon(
      CupertinoIcons.shopping_cart,
      size: _iconSize,
    );
    var prefix = '-';
    var title = S.of(context).debit;
    var isTopUp = false;
    var isReceived = false;
    if (transaction.isCredit) {
      icon = const Icon(
        CupertinoIcons.plus_circled,
        size: _iconSize,
      );
      prefix = '+';
      if (transaction.isCredit) {
        if (!isMyself) {
          title = S.of(context).receivedMoney;
          isReceived = true;
        } else {
          title = S.of(context).topUp.toUpperCase();
          isTopUp = true;
        }
      }
    } else if (transaction.isTransfer) {
      icon = const Icon(
        CupertinoIcons.arrowshape_turn_up_right_circle,
        size: _iconSize,
      );
      title = S.of(context).transfer;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        title: Text(
          S.of(context).transactionDetail,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGroupBox(
                    child: Column(
                      children: [
                        ListTile(
                          leading: icon,
                          title: Text(
                            title.toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          subtitle: Text(
                            '$prefix ${WalletHelpers.parseNumberToCurrencyText(transaction.amount)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Center(
                                  child: Text(
                                S.of(context).paymentSuccessful,
                                style: Theme.of(context).textTheme.titleMedium,
                              )),
                            ],
                          ),
                        ),
                        _buildInfoItem(
                          title: S.of(context).time,
                          description: transaction.createdTime ?? '',
                        ),
                        _buildDivider(),
                        _buildInfoItem(
                          title: S.of(context).transactionFee,
                          description: S.of(context).freeOfCharge,
                        ),
                        _buildDivider(),
                        _buildInfoItem(
                          title: S.of(context).walletBalance,
                          description: WalletHelpers.parseNumberToCurrencyText(
                              transaction.balance),
                        ),
                      ],
                    ),
                  ),
                  if (!isMyself &&
                      !isTopUp &&
                      userCreateTransaction != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        S.of(context).moreInformation.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    _buildGroupBox(
                      child: Column(
                        children: [
                          _buildInfoItem(
                            title: S.of(context).walletName,
                            description:
                                userCreateTransaction!.fullName.toUpperCase(),
                          ),
                          _buildDivider(),
                          _buildInfoItem(
                            title: S.of(context).email,
                            description: userCreateTransaction!.email ?? '',
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (transaction.details.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        S.of(context).noteMessage.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_borderRadius),
                        border: Border.all(
                          width: _borderWidth,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      height: 80,
                      width: double.infinity,
                      child: Text(transaction.details),
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (isReceived) _buildButtonSendBack(),
        ],
      ),
    );
  }

  Widget _buildGroupBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: Theme.of(context).disabledColor,
          width: _borderWidth,
        ),
      ),
      child: child,
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      child: Row(
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).disabledColor)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              description,
              maxLines: 2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Divider(height: 4),
    );
  }

  void _onSendBack() {
    Navigator.of(context).pushNamed(
      RouteList.teraWalletTransfer,
      arguments: TransferArguments(email: userCreateTransaction!.email!),
    );
  }

  Widget _buildButtonSendBack() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _onSendBack,
          child: Text(
            S.of(context).sendBack,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
