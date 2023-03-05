import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../config/banner_config.dart';
import '../helper/helper.dart';

class BannerAnimated extends StatefulWidget {
  final BannerConfig config;

  @override
  const BannerAnimated({Key? key, required this.config}) : super(key: key);

  @override
  State<BannerAnimated> createState() => _BannerAnimatedState();
}

class _BannerAnimatedState extends State<BannerAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.4,
    )..repeat(min: 1.0, max: 1.4, reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(widget.config.padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _controller.value * 1,
                    child: child,
                  );
                },
                child: FadeInImage.memoryNetwork(
                  height: Helper.formatDouble(widget.config.height),
                  width: MediaQuery.of(context).size.width,
                  placeholder: kTransparentImage,
                  image: widget.config.imageBanner!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.width / 15,
            left: MediaQuery.of(context).size.width / 15,
            child: Text(
              widget.config.text!,
              style: const TextStyle(color: Colors.white, fontSize: 28.0),
            ),
          ),
        ],
      ),
    );
  }
}
