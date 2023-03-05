part of 'rating_count_widget.dart';

class RatingCountSkeleton extends StatelessWidget {
  const RatingCountSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).dividerColor,
                      ),
                    ),
                    const Skeleton(
                      width: 38,
                      height: 35,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Skeleton(
                      width: 50,
                      height: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Skeleton(
                  width: 70,
                  height: 10,
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            width: 16,
          ),
          Expanded(
            flex: 9,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                final rating = 5 - index;
                // final count = ratings[index];
                return Row(
                  children: [
                    Row(
                      children: [
                        SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: rating.toDouble(),
                          size: _starSize,
                          color: kRatingColor.primaryStar,
                          borderColor: kRatingColor.borderStar,
                          spacing: 0.0,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const Skeleton(
                          width: 80,
                          height: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Skeleton(
                      width: 30,
                      height: 16,
                    ),
                  ],
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(height: 8);
              },
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
