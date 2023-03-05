import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Review, UserModel;
import '../../../services/index.dart';
import '../../../widgets/common/start_rating.dart';
import '../../base_screen.dart';
import 'index.dart';

class Reviews extends StatefulWidget {
  final String? productId;
  final bool allowRating;
  final bool showYourRatingOnly;

  const Reviews(
    this.productId, {
    this.allowRating = true,
    this.showYourRatingOnly = false,
  });

  @override
  BaseScreen<Reviews> createState() => _StateReviews();
}

class _StateReviews extends BaseScreen<Reviews> {
  final services = Services();
  double rating = 0.0;
  final comment = TextEditingController();
  List<Review>? reviews;
  bool _isSending = false;
  List<dynamic> _images = [];

  @override
  void afterFirstLayout(BuildContext context) {
    getListReviews(context);
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  Future<void> _chooseImages() async {
    try {
      _images = await ImagePicker.select(context, maxFiles: 5);
      // _images = await MultiImagePicker.pickImages(
      //     maxImages: 5, selectedAssets: _images);

      setState(() {});
    } catch (e) {
      _images = [];
    }
  }

  void updateRating(double index) {
    setState(() {
      rating = index;
    });
  }

  void sendReview() async {
    if (rating == 0.0) {
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), S.of(context).ratingFirst);
      return;
    }
    if (comment.text.isEmpty) {
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), S.of(context).commentFirst);
      return;
    }
    final user = Provider.of<UserModel>(context, listen: false);
    _isSending = true;
    setState(() {});
    var data = {
      'review': comment.text,
      'reviewer': user.user!.name,
      'reviewer_email': user.user!.email,
      'rating': rating,
      'status': kAdvanceConfig.enableApprovedReview ? 'approved' : 'hold'
    };
    if (_images.isNotEmpty) {
      var preparedImages =
          await ImageTools.compressAndConvertImagesForUploading(_images);
      data['images'] = preparedImages;
    }
    await services.api
        .createReview(
            productId: widget.productId, data: data, token: user.user!.cookie)!
        .catchError((e) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), e.toString());
    }).then((onValue) {
      if (onValue != null) {
        Tools.showSnackBar(
            ScaffoldMessenger.of(context),
            (kAdvanceConfig.enableApprovedReview)
                ? S.of(context).reviewSent
                : S.of(context).reviewPendingApproval);
        getListReviews(context);
      }
      setState(() {
        rating = 0.0;
        comment.text = '';
        _isSending = false;
        _images.clear();
      });
    });
  }

  void getListReviews(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);
    services.api
        .getReviews(
      widget.productId,
    )!
        .then((onValue) {
      final reviewList = onValue.data;

      if (userModel.loggedIn && widget.showYourRatingOnly) {
        final userEmail = userModel.user!.email;
        reviewList?.retainWhere((element) => element.email == userEmail);
      }
      if (mounted) {
        setState(() {
          reviews = reviewList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRatingAllowed =
        (Provider.of<UserModel>(context).loggedIn) && (widget.allowRating);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 4),
        reviews == null
            ? SizedBox(height: 80, child: kLoadingWidget(context))
            : (reviews!.isEmpty
                ? (widget.showYourRatingOnly
                    ? const SizedBox()
                    : SizedBox(
                        height: 80,
                        child: Center(
                          child: Text(S.of(context).noReviews),
                        ),
                      ))
                : Column(
                    children: <Widget>[
                      for (var i = 0; i < reviews!.length; i++)
                        renderItem(context, reviews![i])
                    ],
                  )),
        const SizedBox(height: 20),
        if (isRatingAllowed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  S.of(context).productRating,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              if (kAdvanceConfig.enableRating)
                Flexible(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SmoothStarRating(
                      label: const Text(''),
                      allowHalfRating: true,
                      onRatingChanged: updateRating,
                      starCount: 5,
                      rating: rating,
                      size: 28.0,
                      color: Theme.of(context).primaryColor,
                      borderColor: Theme.of(context).primaryColor,
                      spacing: 0.0,
                    ),
                  ),
                ),
            ],
          ),
        if (isRatingAllowed)
          Container(
            margin: const EdgeInsets.only(bottom: 40, top: 15.0),
            padding: const EdgeInsets.only(left: 15.0, top: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        enabled: !_isSending,
                        controller: comment,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                            labelText: S.of(context).writeComment),
                      ),
                    ),
                  ],
                ),
                if (_images.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            _images.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: ImagePicker.getThumbnail(
                                    _images[index],
                                    width: 100,
                                    height: 100,
                                  ),
                                )),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _chooseImages,
                      ),
                      Container(
                        height: 30.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Center(
                          child: _isSending
                              ? const SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: sendReview,
                                  child: Text(
                                    S.of(context).send,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  Widget renderItem(context, Review review) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(2.0)),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (kAdvanceConfig.enableRating)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(review.name!,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  SmoothStarRating(
                      label: const Text(''),
                      allowHalfRating: true,
                      starCount: 5,
                      rating: review.rating,
                      size: 12.0,
                      color: theme.primaryColor,
                      borderColor: theme.primaryColor,
                      spacing: 0.0),
                ],
              ),
            const SizedBox(height: 10),
            Text(review.review!,
                style: const TextStyle(color: kGrey600, fontSize: 14)),
            const SizedBox(height: 4),
            if (review.images.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    review.images.length,
                    (i) => InkWell(
                      onTap: () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return ImageGalery(
                                  images: review.images, index: i);
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ImageResize(
                          url: review.images[i],
                          fit: BoxFit.cover,
                          height: 80.0,
                          width: 80.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(timeago.format(review.createdAt),
                style: const TextStyle(color: kGrey400, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
