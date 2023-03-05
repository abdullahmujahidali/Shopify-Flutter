import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/transaction.dart';
import '../../../models/tera_wallet/index.dart';
import '../../../widgets/common/refresh_scroll_physics.dart';
import '../helpers/wallet_helpers.dart';
import 'widgets/transaction_item.dart';
import 'widgets/transaction_item_skeleton.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  WalletModel get _walletModel =>
      Provider.of<WalletModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        _walletModel.getBalance();
        _walletModel.getListTransaction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        physics: const RefreshScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(S.of(context).myWallet),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await Future.wait([
                _walletModel.getBalance(),
                _walletModel.refreshListTransaction(),
              ]);
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCard(),
                        const SizedBox(height: 16),
                        _buildCardAction(),
                        const SizedBox(height: 16),
                        Text(
                          '${S.of(context).lastTransactions} 💰',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  Selector<WalletTransactionModel, List<Transaction>?>(
                    selector: (_, model) => model.data.take(10).toList(),
                    builder: (context, listTransaction, child) {
                      if (listTransaction == null) {
                        return ListView.separated(
                          itemBuilder: (_, index) {
                            return const TransactionItemSkeleton();
                          },
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          shrinkWrap: true,
                          separatorBuilder: (_, __) => const Divider(),
                        );
                      }

                      if (listTransaction.isEmpty) {
                        return Text(S.of(context).doNotAnyTransactions);
                      }

                      return ListView.separated(
                        itemBuilder: (_, index) {
                          final transaction = listTransaction[index];
                          return TransactionItem(
                            key: ValueKey(transaction.id),
                            transaction: transaction,
                          );
                        },
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listTransaction.length,
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const Divider(height: 0),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: math.pi / 35,
              child: _buildCardFake(
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
            ),
            Transform.rotate(
              angle: -math.pi / 35,
              child: _buildCardFake(
                  Theme.of(context).colorScheme.secondary.withOpacity(0.3)),
            ),
            Consumer<WalletModel>(builder: (context, model, child) {
              return _buildCardInfo(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                fullName: model.user.fullName,
                balance: '${model.balance}',
                cardId: '5345345345',
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFake(Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: color,
      ),
      height: MediaQuery.of(context).size.height / 4 - 8,
    );
  }

  Widget _buildCardInfo({
    required Color color,
    required String fullName,
    required String cardId,
    required String balance,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
      ),
      height: MediaQuery.of(context).size.height / 4,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineSmall!
                          .copyWith(
                            color: Colors.white,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    // const SizedBox(height: 12),
                    // Text(
                    //   cardId,
                    //   style: Theme.of(context).textTheme.headline6!.copyWith(
                    //         color: Colors.white.withOpacity(0.8),
                    //       ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  'TeraWallet',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).balance,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
              ),
              Text(
                WalletHelpers.parseNumberToCurrencyText(
                    double.tryParse(balance) ?? 0),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCardAction() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCardActionItem(
            actionName: S.of(context).topUp,
            onTap: () =>
                Navigator.of(context).pushNamed(RouteList.teraWalletTopUp),
            color: Colors.red,
            icon: const Icon(
              CupertinoIcons.square_arrow_right,
              color: Colors.white,
            ),
          ),
          _buildCardActionItem(
            actionName: S.of(context).transfer,
            onTap: () =>
                Navigator.of(context).pushNamed(RouteList.teraWalletTransfer),
            color: Colors.green,
            icon: const Icon(
              CupertinoIcons.arrow_right_arrow_left,
              color: Colors.white,
            ),
          ),
          _buildCardActionItem(
            actionName: S.of(context).historyTransaction,
            onTap: () => Navigator.of(context)
                .pushNamed(RouteList.teraWalletTransactions),
            color: Colors.cyan,
            icon: const Icon(
              Icons.history,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardActionItem({
    required String actionName,
    required Widget icon,
    Color? color,
    VoidCallback? onTap,
  }) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            padding: const EdgeInsets.all(12),
            child: icon,
          ),
          const SizedBox(height: 8),
          Text(
            actionName,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
