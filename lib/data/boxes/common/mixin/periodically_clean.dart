part of '../../../boxes.dart';

/// Use this mixin to periodically clean up the box.
/// Need to override [cleanInterval] to set the maximum age of the data.
/// The box data will be cleaned up upon init
/// once the last time it was cleaned up is older than [cleanInterval].
mixin PeriodicallyCleanMixin on FluxBox {
  /// Override this to enable periodic cleaning.
  Duration get cleanInterval => Duration.zero;

  @override
  Future<void> init() async {
    await super.init();

    final key = '${BoxKeys.hiveBoxCleanIntervalPrefix}$boxKey';

    /// Enable periodic cleaning only when [cleanInterval] > 0.
    if (cleanInterval.inMilliseconds > 0) {
      final lastClean = box.get(key);

      /// If [lastClean] is null, it means that this is the first time init.
      /// No need to clean.
      if (lastClean == null) {
        await box.put(key, DateTime.now().millisecondsSinceEpoch);
        return;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      if ((lastClean + cleanInterval.inMilliseconds) < now) {
        await box.clear();
        await box.put(key, DateTime.now().millisecondsSinceEpoch);
      }
    }
  }
}
