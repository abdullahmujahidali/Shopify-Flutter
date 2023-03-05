import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../screens/base_screen.dart';
import 'flux_image.dart';

class AnimatedSplash extends StatelessWidget {
  const AnimatedSplash({
    Key? key,
    required this.next,
    required this.imagePath,
    this.animationEffect = 'fade-in',
    this.duration = 1000,
    this.backgroundColor = Colors.white,
    this.boxFit = BoxFit.contain,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  }) : super(key: key);

  final Function? next;
  final String imagePath;
  final int duration;
  final String animationEffect;
  final Color backgroundColor;
  final BoxFit boxFit;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: paddingTop,
          bottom: paddingBottom,
          left: paddingLeft,
          right: paddingRight,
        ),
        child: _AnimatedSplashChild(
          next: next,
          imagePath: imagePath,
          duration: duration,
          animationEffect: animationEffect,
          boxFit: boxFit,
        ),
      ),
    );
  }
}

class _AnimatedSplashChild extends StatefulWidget {
  final Function? next;
  final String imagePath;
  final int duration;
  final String animationEffect;
  final BoxFit boxFit;

  const _AnimatedSplashChild({
    required this.next,
    required this.imagePath,
    required this.animationEffect,
    this.duration = 1000,
    this.boxFit = BoxFit.contain,
  });

  @override
  __AnimatedSplashStateChild createState() => __AnimatedSplashStateChild();
}

class __AnimatedSplashStateChild extends BaseScreen<_AnimatedSplashChild>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    ));
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1500)).then(
          (value) {
            widget.next?.call();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.reset();
    _animationController.dispose();
  }

  Widget _buildAnimation(Size size) {
    switch (widget.animationEffect) {
      case SplashScreenTypeConstants.fadeIn:
        {
          return FadeTransition(
            opacity: _animation,
            child: FluxImage(
              imageUrl: widget.imagePath,
              fit: widget.boxFit,
              height: size.height,
              width: size.width,
            ),
          );
        }
      case SplashScreenTypeConstants.zoomIn:
        {
          return ScaleTransition(
            scale: _animation,
            child: FluxImage(
              imageUrl: widget.imagePath,
              fit: widget.boxFit,
              height: size.height,
              width: size.width,
            ),
          );
        }
      case SplashScreenTypeConstants.zoomOut:
        {
          return ScaleTransition(
            scale: Tween(begin: 2.1, end: 1.0).animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInCirc)),
            child: FluxImage(
              imageUrl: widget.imagePath,
              fit: widget.boxFit,
              height: size.height,
              width: size.width,
            ),
          );
        }
      case SplashScreenTypeConstants.topDown:
      default:
        {
          return SizeTransition(
            sizeFactor: _animation,
            child: FluxImage(
              imageUrl: widget.imagePath,
              fit: widget.boxFit,
              height: size.height,
              width: size.width,
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _buildAnimation(size);
  }
}
