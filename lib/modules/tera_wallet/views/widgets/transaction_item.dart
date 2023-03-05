import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../models/entities/transaction.dart';
import '../../../../models/user_model.dart';
import '../../helpers/wallet_helpers.dart';
import '../transaction_detail_screen.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    var icon = const Icon(CupertinoIcons.shopping_cart);
    var prefix = '-';
    if (transaction.isCredit) {
      icon = const Icon(CupertinoIcons.plus_circled);
      prefix = '+';
    } else if (transaction.isTransfer) {
      icon = const Icon(CupertinoIcons.arrowshape_turn_up_right_circle);
    }

    var userCreate = transaction.userCreate;
    final currentUser = Provider.of<UserModel>(context, listen: false).user!;

    var title = transaction.details;
    if (transaction.isCredit && userCreate?.id != currentUser.id) {
      title =
          'Received money from ${transaction.userCreate?.fullName.toUpperCase()}';
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 20,
      minVerticalPadding: 8,
      minLeadingWidth: 24,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.createdTime ?? '',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).disabledColor),
          ),
          const SizedBox(height: 4),
          Text(
              'Wallet balance ${WalletHelpers.parseNumberToCurrencyText(transaction.balance)}'),
        ],
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text(
          '$prefix ${WalletHelpers.parseNumberToCurrencyText(transaction.amount)}',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: icon,
      ),
      onTap: () => Navigator.of(context).pushNamed(
        RouteList.teraWalletTransactionDetail,
        arguments: TransactionDetailArguments(transaction: transaction),
      ),
    );
  }
}
