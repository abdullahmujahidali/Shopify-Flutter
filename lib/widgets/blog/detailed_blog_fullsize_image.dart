import 'dart:ui' as ui show ImageFilter;

import 'package:flutter/material.dart';

import '../../common/tools.dart';
import '../../models/entities/blog.dart';
import 'detailed_blog_mixin.dart';

class FullImageType extends StatefulWidget {
  final Blog item;

  const FullImageType({Key? key, required this.item}) : super(key: key);

  @override
  State<FullImageType> createState() => _FullImageTypeState();
}

class _FullImageTypeState extends State<FullImageType> with DetailedBlogMixin {
  Blog blogData = const Blog.empty();
  final _scrollController = ScrollController();
  double _opacity = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    blogData = widget.item;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FullImageType oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      blogData = widget.item;
    }
  }

  void _scrollListener() {
    if (_scrollController.offset == 0 && _opacity == 1) {
      setState(() => _opacity = 0);
    } else if (_opacity == 0) {
      setState(() => _opacity = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ImageResize(
            url: blogData.imageFeature,
            fit: BoxFit.fitHeight,
            size: kSize.medium,
          ),
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _opacity,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black54, Colors.black45],
              stops: [0.1, 0.3, 0.5],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [renderBlogFunctionButtons(blogData, context)],
            leading: IconButton(
              color: Colors.white.withOpacity(0.8),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: Navigator.of(context).pop,
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.6,
                              bottom: 15),
                          child: Text(
                            blogData.title,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(5.0),
                                child: const Icon(
                                  Icons.person,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'by ${blogData.author} ',
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    blogData.date,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        renderAudioWidget(blogData, context),
                        renderBlogContentWithTextEnhancement(blogData),
                        renderRelatedBlog(blogData.categoryId),
                        renderCommentLayout(blogData.id),
                        renderCommentInput(blogData.id),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // if (kAdConfig['enable'] ?? false)
        //   Container(
        //     alignment: Alignment.bottomCenter,
        //     child: _buildChildWidgetAd(),
        //   ),
      ],
    );
  }

  // void _initAds() {
  //   Ads.googleAdInit();
  //   Ads.facebookAdInit();
  //   switch (kAdConfig['type']) {
  //     case kAdType.googleBanner:
  //       {
  //         // Ads.createBannerAd();
  //         // Ads.showBanner();
  //         break;
  //       }
  //     case kAdType.googleInterstitial:
  //       {
  //         // Ads.createInterstitialAd();
  //         // Ads.showInterstitialAd();
  //         break;
  //       }
  //     case kAdType.googleReward:
  //       {
  //         Ads.showRewardedVideoAd();
  //         break;
  //       }
  //     case kAdType.facebookBanner:
  //       {
  //         setState(() {
  //           isFBBannerShown = true;
  //         });
  //         break;
  //       }
  //     case kAdType.facebookNative:
  //       {
  //         setState(() {
  //           isFBNativeAdShown = true;
  //         });
  //         break;
  //       }
  //     case kAdType.facebookNativeBanner:
  //       {
  //         setState(() {
  //           isFBNativeBannerAdShown = true;
  //         });
  //         break;
  //       }
  //     case kAdType.facebookInterstitial:
  //       {
  //         Ads.showFacebookInterstitialAd();
  //         break;
  //       }
  //   }
  // }
}
