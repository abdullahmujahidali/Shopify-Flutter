import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../index.dart';

class SliderTestimonial extends StatefulWidget {
  final SliderTestimonialConfig config;

  const SliderTestimonial({required this.config, Key? key}) : super(key: key);

  @override
  State<SliderTestimonial> createState() => _StateSliderTestimonial();
}

class _StateSliderTestimonial extends State<SliderTestimonial> {
  ValueNotifier<int> position = ValueNotifier(0);
  PageController? _controller;
  Timer? timer;
  bool get autoPlay => widget.config.autoPlay;
  int get intervalTime => widget.config.intervalTime;

  @override
  void initState() {
    _controller = PageController();
    autoPlayBanner();

    super.initState();
  }

  void autoPlayBanner() {
    List? items = widget.config.items;
    timer = Timer.periodic(Duration(seconds: intervalTime), (callback) {
      if (!autoPlay) {
        timer?.cancel();
        return;
      }
      if (position.value >= items.length - 1 && _controller!.hasClients) {
        position.value = 0;
        _controller!.jumpToPage(position.value);
      } else {
        if (_controller!.hasClients) {
          _controller!.animateToPage(position.value + 1,
              duration: const Duration(seconds: 1), curve: Curves.easeInOut);
        }
      }
    });
  }

  @override
  void dispose() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    _controller?.dispose();
    position.dispose();
    super.dispose();
  }

  Widget getTestimonialPageView() {
    List items = widget.config.items;

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              position.value = index;
            },
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                renderTestimonialItem(config: items[i]),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SmoothPageIndicator(
              controller: _controller!, // PageController
              count: items.length,
              effect: const SlideEffect(
                spacing: 8.0,
                radius: 5.0,
                dotWidth: 24.0,
                dotHeight: 2.0,
                paintStyle: PaintingStyle.fill,
                strokeWidth: 1.5,
                dotColor: Colors.black12,
                activeDotColor: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderTestimonialItem({required TestimonialConfig config}) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: TestimonialLayout(config: config),
    );
  }

  Widget renderTestimonialSlider(width) {
    List? items = widget.config.items;

    switch (widget.config.type) {
      case 'swiper':
        return Swiper(
          onIndexChanged: (index) {
            position.value = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderTestimonialItem(config: items[index]);
          },
          itemCount: items.length,
          viewportFraction: 0.85,
          scale: 0.9,
          duration: intervalTime * 100,
        );
      case 'tinder':
        return Swiper(
          onIndexChanged: (index) {
            position.value = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderTestimonialItem(config: items[index]);
          },
          itemCount: items.length,
          itemWidth: width,
          itemHeight: width * 1.2,
          layout: SwiperLayout.TINDER,
          duration: intervalTime * 100,
        );
      case 'stack':
        return Swiper(
          onIndexChanged: (index) {
            position.value = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderTestimonialItem(config: items[index]);
          },
          itemCount: items.length,
          itemWidth: width - 40,
          layout: SwiperLayout.STACK,
          duration: intervalTime * 100,
        );
      case 'custom':
        return Swiper(
          onIndexChanged: (index) {
            position.value = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderTestimonialItem(config: items[index]);
          },
          itemCount: items.length,
          itemWidth: width - 40,
          itemHeight: width + 100,
          duration: intervalTime * 100,
          layout: SwiperLayout.CUSTOM,
          customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
              .addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate(
            [
              const Offset(-370.0, -40.0),
              const Offset(0.0, 0.0),
              const Offset(370.0, -40.0)
            ],
          ),
        );
      default:
        return getTestimonialPageView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: widget.config.height.toDouble(),
      margin: EdgeInsets.only(
        left: widget.config.marginLeft.toDouble(),
        right: widget.config.marginRight.toDouble(),
        top: widget.config.marginTop.toDouble(),
        bottom: widget.config.marginBottom.toDouble(),
      ),
      child: renderTestimonialSlider(screenSize.width),
    );
  }
}
