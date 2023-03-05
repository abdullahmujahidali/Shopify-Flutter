import 'package:flutter/material.dart';

class StoryProgressIndicator extends StatefulWidget {
  final double indicatorHeight;
  final bool enable;
  final bool finished;
  final Function() onFinish;
  final int time;

  const StoryProgressIndicator({
    this.indicatorHeight = 5,
    this.enable = false,
    this.finished = false,
    this.time = 10,
    required this.onFinish,
  }) : assert(indicatorHeight > 0,
            '[indicatorHeight] should not be null or less than 1');

  @override
  State<StoryProgressIndicator> createState() => _StateStoryProgressIndicator();
}

class _StateStoryProgressIndicator extends State<StoryProgressIndicator>
    with TickerProviderStateMixin {
  AnimationController? indicatorController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    indicatorController = AnimationController(
        vsync: this, duration: Duration(seconds: widget.time));
    animation = Tween<double>(begin: 0, end: 1).animate(indicatorController!);
    if (widget.enable) {
      indicatorController?.forward();
    }
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    indicatorController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StoryProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enable != oldWidget.enable && widget.enable) {
      indicatorController?.forward();
    }
    if (widget.enable != oldWidget.enable && !widget.enable) {
      indicatorController?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.fromHeight(
            widget.indicatorHeight,
          ),
          foregroundPainter: IndicatorOval(
            Colors.white.withOpacity(0.8),
            widget.finished ? 1.0 : animation.value,
          ),
          painter: IndicatorOval(
            Colors.white.withOpacity(0.4),
            1.0,
          ),
        );
      },
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  IndicatorOval(this.color, this.widthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * widthFactor, size.height),
            const Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
