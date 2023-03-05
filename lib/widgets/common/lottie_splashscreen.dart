import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieSplashScreen extends StatefulWidget {
  final String imageUrl;
  final int duration;
  final Function? onSuccess;
  final Color backgroundColor;
  final BoxFit boxFit;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  const LottieSplashScreen({
    required this.imageUrl,
    this.duration = 1000,
    this.onSuccess,
    this.backgroundColor = Colors.white,
    this.boxFit = BoxFit.contain,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

  @override
  State<LottieSplashScreen> createState() => _StateLottieSplashScreen();
}

class _StateLottieSplashScreen extends State<LottieSplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        Future.delayed(Duration(milliseconds: widget.duration), () {
          widget.onSuccess?.call();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: widget.backgroundColor,
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      child: widget.imageUrl.startsWith('http')
          ? Lottie.network(
              widget.imageUrl,
              errorBuilder: (_, __, ___) {
                return const SizedBox();
              },
              fit: widget.boxFit,
            )
          : Lottie.asset(
              widget.imageUrl,
              fit: widget.boxFit,
              errorBuilder: (_, __, ___) {
                return const SizedBox();
              },
            ),
    );
  }
}
