import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/entities/user.dart';
import 'vendor_information/vendor_information_index.dart';

class VendorOnBoarding extends StatefulWidget {
  final VoidCallback onFinish;
  final User user;

  const VendorOnBoarding({Key? key, required this.onFinish, required this.user})
      : super(key: key);

  @override
  State<VendorOnBoarding> createState() => _VendorOnBoardingState();
}

class _VendorOnBoardingState extends State<VendorOnBoarding> {
  var _hasClickedDone = false;

  List<ContentConfig> getSlides(List<dynamic> data) {
    final slides = <ContentConfig>[];

    for (var i = 0; i < data.length; i++) {
      var slide = ContentConfig(
          title: data[i]['title'],
          description: data[i]['desc'],
          marginTitle: const EdgeInsets.only(
            top: 125.0,
            bottom: 50.0,
          ),
          maxLineTextDescription: 2,
          styleTitle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: kGrey900,
          ),
          backgroundColor: Colors.white,
          marginDescription: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 0),
          styleDescription: const TextStyle(
            fontSize: 15.0,
            color: kGrey600,
          ),
          foregroundImageFit: BoxFit.fitWidth,
          pathImage: data[i]['image']);
      slides.add(slide);
    }
    return slides;
  }

  @override
  Widget build(BuildContext context) {
    final data = vendorOnBoarding;

    if (data.isEmpty) {
      return VendorIndex(
        userCookie: widget.user.cookie!,
        onFinish: widget.onFinish,
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IntroSlider(
          listContentConfig: getSlides(data),
          renderSkipBtn: Text(
            S.of(context).skip,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          renderDoneBtn: Text(
            S.of(context).done,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          renderPrevBtn: Text(
            S.of(context).prev,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          renderNextBtn: Text(
            S.of(context).next,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          isShowDoneBtn: true,
          onDonePress: _onNextScreen,
        ),
      ),
    );
  }

  void _onNextScreen() {
    if (_hasClickedDone) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VendorIndex(
          userCookie: widget.user.cookie!,
          onFinish: widget.onFinish,
        ),
      ),
    );
    _hasClickedDone = true;
  }
}
