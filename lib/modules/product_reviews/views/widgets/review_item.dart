import 'package:flutter/material.dart';

import '../../../../common/config.dart';
import '../../../../common/tools/image_resize.dart';
import '../../../../screens/detail/widgets/image_galery.dart';
import '../../../../widgets/common/start_rating.dart';
import '../../../../widgets/html/index.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    Key? key,
    required this.name,
    required this.showRatingStar,
    required this.rating,
    required this.date,
    required this.content,
    required this.images,
    this.verified = false,
  }) : super(key: key);

  final String name;
  final bool showRatingStar;
  final double rating;
  final List<String>? images;
  final String date;
  final String content;
  final bool verified;

  List<String> get imagesUrl => images ?? <String>[];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const CircleAvatar(
          //   radius: 14,
          //   backgroundColor: Colors.grey,
          //   child: Icon(
          //     Icons.person,
          //     color: Colors.white,
          //   ),
          // ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 5.0),
                      const Icon(
                        Icons.verified,
                        size: 15.0,
                        color: Colors.green,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        date,
                        style: Theme.of(context).textTheme.labelLarge!,
                      ),
                    ),
                    if (showRatingStar)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: rating,
                          size: 14.0,
                          borderColor: kRatingColor.borderStar,
                          spacing: 0.0,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5.0),
                HtmlWidget(
                  content,
                  textStyle: Theme.of(context).textTheme.bodyLarge!,
                ),
                const SizedBox(height: 10.0),
                if (imagesUrl.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        imagesUrl.length,
                        (i) => InkWell(
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ImageGalery(
                                  images: imagesUrl,
                                  index: i,
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ImageResize(
                              url: imagesUrl[i],
                              fit: BoxFit.cover,
                              height: 120.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
