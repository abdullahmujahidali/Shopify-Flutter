import 'package:flutter/material.dart';

class AnimatedLinearProgressIndicator extends StatefulWidget {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double minHeight;
  final Duration duration;

  const AnimatedLinearProgressIndicator({
    Key? key,
    required this.value,
    this.color = Colors.orangeAccent,
    this.backgroundColor = Colors.grey,
    this.minHeight = 6,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  State<AnimatedLinearProgressIndicator> createState() =>
      _AnimatedLinearProgressIndicatorState();
}

class _AnimatedLinearProgressIndicatorState
    extends State<AnimatedLinearProgressIndicator>
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
  void didUpdateWidget(AnimatedLinearProgressIndicator oldWidget) {
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
      builder: (_, __) {
        return LinearProgressIndicator(
          value: _animation.value,
          minHeight: widget.minHeight,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
          backgroundColor: widget.backgroundColor,
        );
      },
    );
  }
}
