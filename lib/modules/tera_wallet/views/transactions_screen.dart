import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/entities/transaction.dart';
import '../../../models/tera_wallet/index.dart';
import '../../../widgets/common/paging_list.dart';
import 'widgets/transaction_item.dart';
import 'widgets/transaction_item_skeleton.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        title: Text(
          S.of(context).historyTransaction,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: PagingList<WalletTransactionModel, Transaction>(
        lengthLoadingWidget: 10,
        loadingWidget: Column(
          children: const [
            TransactionItemSkeleton(),
            Divider(),
          ],
        ),
        itemBuilder: (_, transaction, index) {
          return Column(
            children: [
              TransactionItem(
                key: ValueKey(transaction.id),
                transaction: transaction,
              ),
              const Divider(height: 0),
            ],
          );
        },
      ),
    );
  }
}
