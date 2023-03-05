import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

class WarningCurrency extends StatelessWidget {
  const WarningCurrency({Key? key, required this.defaultCurrency})
      : super(key: key);
  final String defaultCurrency;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Row(
          children: [
            const Icon(Icons.info),
            const SizedBox(width: 15.0),
            Expanded(
                child: Text(S
                    .of(context)
                    .warningCurrencyMessageForWallet(defaultCurrency)))
          ],
        ),
      ),
    );
  }
}
