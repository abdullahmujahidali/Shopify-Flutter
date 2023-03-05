import 'dart:async';

import 'package:flutter/material.dart';

mixin CountdownMixin<T extends StatefulWidget> on State<T> {
  late Timer _timer;
  int? _time;

  final ValueNotifier<int> timeCtr = ValueNotifier(0);

  int get initCountdownTime;

  int get timeStampSeconds {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  void cancelTimer() {}

  void startTimer() {
    timeCtr.value = initCountdownTime;
    _time = timeStampSeconds + initCountdownTime;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (timeCtr.value == 0) {
          timer.cancel();
          cancelTimer();
        } else {
          final startTime = _time;
          if (startTime != null) {
            timeCtr.value = startTime - timeStampSeconds;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }
}
