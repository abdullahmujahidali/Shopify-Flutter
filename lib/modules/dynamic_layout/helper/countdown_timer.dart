import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final Duration countdownDuration;
  final VoidCallback? onEnd;

  const CountDownTimer(this.countdownDuration, {Key? key, this.onEnd})
      : super(key: key);

  @override
  StateCountDownTimer createState() => StateCountDownTimer();
}

class StateCountDownTimer extends State<CountDownTimer>
    with SingleTickerProviderStateMixin {
  ValueNotifier<Duration> valueNotifier = ValueNotifier(Duration.zero);

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: widget.countdownDuration, vsync: this);
    animation = Tween<double>(
            begin: widget.countdownDuration.inMilliseconds.toDouble(), end: 0)
        .animate(controller);
    animation
      ..addListener(_listener)
      ..addStatusListener(_statusListener);
    controller.forward();
  }

  void _listener() {
    var timer = Duration(milliseconds: animation.value.toInt());
    if (timer.inSeconds != valueNotifier.value.inSeconds) {
      valueNotifier.value = timer;
    }
  }

  void _statusListener(status) {
    if (status == AnimationStatus.completed) {
      widget.onEnd?.call();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.removeStatusListener(_statusListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 22.0;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ValueListenableBuilder<Duration>(
        valueListenable: valueNotifier,
        builder: (context, value, child) {
          if (value.inMilliseconds == 0) {
            return const SizedBox();
          }
          final seconds = value.inSeconds % 60;
          final minutes = value.inMinutes % 60;
          final hours = value.inHours;
          final days = value.inDays;
          var listView = [hours, ':', minutes, ':', seconds];
          if (hours > 24) {
            listView = [days, ':', '24', ':', minutes, ':', seconds];
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: listView
                .map(
                  (item) => item == ':'
                      ? Container(
                          alignment: Alignment.center,
                          height: size,
                          child: Text(
                            '$item',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 1.0,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: size,
                            minHeight: size,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 6.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '$item'.toString().padLeft(2, '0'),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
