import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../generated/l10n.dart';
import '../models/app_model.dart';

class AppError extends StatelessWidget {
  const AppError({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (_, model, __) {
        return WillPopScope(
          onWillPop: () async {
            if (model.appConfig != null) {
              return true;
            }
            return false;
          },
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Lottie.asset(
                    'assets/images/Oops.json',
                    alignment: Alignment.center,
                  ),
                ),
                Text(
                  'Opps!',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Text(
                  S.of(context).failedToLoadAppConfig,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0.0,
                    padding: const EdgeInsets.all(8),
                  ),
                  icon: model.isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : const Icon(Icons.replay_outlined),
                  onPressed: () async {
                    /// reload app config
                    var appConfig =
                        await model.loadAppConfig(config: kLayoutConfig);
                    if (appConfig != null) {
                      Navigator.of(context).pop();
                    }
                  },
                  label: Text(
                    S.of(context).retry,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
