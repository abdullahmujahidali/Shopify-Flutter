import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../widgets/common/flux_image.dart';
import '../config/banner_config.dart';
import '../header/header_text.dart';
import '../helper/helper.dart';
import 'banner_items.dart';

/// The Banner Group type to display the image as multi columns
class BannerSlider extends StatefulWidget {
  final BannerConfig config;
  final Function onTap;

  const BannerSlider({required this.config, required this.onTap, Key? key})
      : super(key: key);

  @override
  State<BannerSlider> createState() => _StateBannerSlider();
}

class _StateBannerSlider extends State<BannerSlider> {
  int position = 0;
  PageController? _controller;
  late bool autoPlay;
  Timer? timer;
  late int intervalTime;

  @override
  void initState() {
    autoPlay = widget.config.autoPlay;
    _controller = PageController();
    intervalTime = widget.config.intervalTime ?? 3;
    autoPlayBanner();

    super.initState();
  }

  void autoPlayBanner() {
    List? items = widget.config.items;
    timer = Timer.periodic(Duration(seconds: intervalTime), (callback) {
      if (widget.config.design != 'default' || !autoPlay) {
        timer!.cancel();
      } else if (widget.config.design == 'default' && autoPlay) {
        if (position >= items.length - 1 && _controller!.hasClients) {
          _controller!.jumpToPage(0);
        } else {
          if (_controller!.hasClients) {
            _controller!.animateToPage(position + 1,
                duration: const Duration(seconds: 1), curve: Curves.easeInOut);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }

    _controller!.dispose();
    super.dispose();
  }

  Widget getBannerPageView(width) {
    List items = widget.config.items;
    var showNumber = widget.config.showNumber;
    var boxFit = widget.config.fit;

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                position = index;
              });
            },
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                BannerImageItem(
                  config: items[i],
                  width: width,
                  boxFit: boxFit,
                  padding: widget.config.padding,
                  radius: widget.config.radius,
                  onTap: widget.onTap,
                ),
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
          showNumber
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, right: 0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.6)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        child: Text(
                          '${position + 1}/${items.length}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget renderBannerItem({required BannerItemConfig config, double? width}) {
    return BannerImageItem(
      config: config,
      width: width,
      boxFit: widget.config.fit,
      radius: widget.config.radius,
      padding: widget.config.padding,
      onTap: widget.onTap,
    );
  }

  Widget renderBanner(width) {
    List? items = widget.config.items;

    switch (widget.config.design) {
      case 'swiper':
        return Swiper(
          onIndexChanged: (index) {
            setState(() {
              position = index;
            });
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(config: items[index], width: width);
          },
          itemCount: items.length,
          viewportFraction: 0.85,
          scale: 0.9,
          duration: intervalTime * 100,
        );
      case 'tinder':
        return Swiper(
          onIndexChanged: (index) {
            setState(() {
              position = index;
            });
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(config: items[index], width: width);
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
            setState(() {
              position = index;
            });
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(config: items[index], width: width);
          },
          itemCount: items.length,
          itemWidth: width - 40,
          layout: SwiperLayout.STACK,
          duration: intervalTime * 100,
        );
      case 'custom':
        return Swiper(
          onIndexChanged: (index) {
            setState(() {
              position = index;
            });
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(config: items[index], width: width);
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
        return getBannerPageView(width);
    }
  }

  double? bannerPercent(width) {
    final screenSize = MediaQuery.of(context).size;
    return Helper.formatDouble(
        widget.config.height ?? 0.5 / (screenSize.height / width));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var isBlur = widget.config.isBlur;

    List? items = widget.config.items;
    var bannerExtraHeight =
        screenSize.height * (widget.config.title != null ? 0.12 : 0.0);
    var upHeight = Helper.formatDouble(widget.config.upHeight);

    //Set autoplay for default template
    autoPlay = widget.config.autoPlay;
    if (widget.config.design == 'default' && timer != null) {
      if (!autoPlay) {
        if (timer!.isActive) {
          timer!.cancel();
        }
      } else {
        if (!timer!.isActive) {
          Future.delayed(Duration(seconds: intervalTime), () => autoPlayBanner);
        }
      }
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        var bannerPercentWidth = bannerPercent(constraint.maxWidth)!;
        var height = screenSize.height * bannerPercentWidth +
            bannerExtraHeight +
            upHeight!;
        if (items.isEmpty) {
          return widget.config.title != null
              ? HeaderText(config: widget.config.title!)
              : const SizedBox();
        }
        BannerItemConfig item = items[position];
        return FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            margin: EdgeInsets.only(
              left: widget.config.marginLeft,
              right: widget.config.marginRight,
              top: widget.config.marginTop,
              bottom: widget.config.marginBottom,
            ),
            child: Stack(
              children: <Widget>[
                if (widget.config.showBackground)
                  SizedBox(
                    height: height,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.elliptical(100, 6),
                        ),
                        child: isBlur
                            ? ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 5.0,
                                ),
                                child: Transform.scale(
                                  scale: 3,
                                  child: FluxImage(
                                    imageUrl: item.background ?? item.image,
                                    fit: BoxFit.fill,
                                    width: screenSize.width + upHeight,
                                  ),
                                ),
                              )
                            : FluxImage(
                                imageUrl: item.background ?? item.image,
                                fit: BoxFit.fill,
                                width: constraint.maxWidth,
                                height: screenSize.height * bannerPercentWidth +
                                    bannerExtraHeight +
                                    upHeight,
                              ),
                      ),
                    ),
                  ),
                Column(
                  children: [
                    if (widget.config.title != null)
                      HeaderText(config: widget.config.title!),
                    SizedBox(
                      height: screenSize.height * bannerPercentWidth,
                      child: renderBanner(constraint.maxWidth),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
