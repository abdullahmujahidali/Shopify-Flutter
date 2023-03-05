import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/html/index.dart';

class TransferFailArguments {
  final String errorMessage;

  TransferFailArguments({required this.errorMessage});
}

class TransferFailScreen extends StatelessWidget {
  const TransferFailScreen({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).transactionResult,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PhysicalModel(
                    color: Theme.of(context).colorScheme.background,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.clear_circled_solid,
                              size: 50,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 24),
                            Center(
                                child: Text(
                              '${S.of(context).transferFailed}!',
                              style: Theme.of(context).textTheme.titleMedium,
                            )),
                            const SizedBox(height: 8),
                            Center(child: HtmlWidget(errorMessage)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                      (route) => route.settings.name == RouteList.myWallet);
                },
                child: Text(
                  S.of(context).backToWallet,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
