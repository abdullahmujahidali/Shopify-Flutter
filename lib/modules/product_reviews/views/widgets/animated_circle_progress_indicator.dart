import 'package:flutter/material.dart';

class AnimatedCircleProgressIndicator extends StatefulWidget {
  final double value;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final double size;
  final Duration duration;

  const AnimatedCircleProgressIndicator({
    Key? key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4,
    this.size = 40,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  State<AnimatedCircleProgressIndicator> createState() =>
      _AnimatedCircleProgressIndicatorState();
}

class _AnimatedCircleProgressIndicatorState
    extends State<AnimatedCircleProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(_animation);
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(AnimatedCircleProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: 0,
        end: widget.value,
      ).animate(_animation);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            value: _animation.value,
            valueColor: AlwaysStoppedAnimation(widget.color),
            backgroundColor: widget.backgroundColor,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}