import 'package:flutter/material.dart';

class AnimatedNumber extends StatefulWidget {
  final double number;
  final TextStyle? style;
  final Duration duration;

  final bool _isDouble;

  AnimatedNumber({
    Key? key,
    required int value,
    this.style,
    this.duration = const Duration(milliseconds: 250),
  })  : number = value.toDouble(),
        _isDouble = false,
        super(key: key);

  const AnimatedNumber.double({
    Key? key,
    required double value,
    this.style,
    this.duration = const Duration(milliseconds: 250),
  })  : number = value,
        _isDouble = true,
        super(key: key);

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _number;

  @override
  void initState() {
    super.initState();
    _number = widget.number;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = Tween<double>(
      begin: 0,
      end: _number.toDouble(),
    ).animate(_animation);
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.number != widget.number) {
      _number = widget.number;
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
        if (widget._isDouble) {
          return Text(
            _animation.value.toStringAsFixed(1),
            style: widget.style,
          );
        }
        return Text(
          _animation.value.toInt().toString(),
          style: widget.style,
        );
      },
    );
  }
}
