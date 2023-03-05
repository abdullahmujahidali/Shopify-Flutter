import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../../../widgets/common/index.dart';
import '../config/testimonial_config.dart';

class TestimonialChat extends StatelessWidget {
  final TestimonialConfig config;
  const TestimonialChat({required this.config});

  Widget renderAuthor(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (config.name != null)
          Text(
            config.name.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        if (config.major != null)
          Text(
            config.major.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        if (config.rating != null) ...[
          const SizedBox(height: 10),
          SmoothStarRating(
            size: 10,
            rating: config.rating?.toDouble(),
          )
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: config.marginLeft.toDouble(),
        right: config.marginRight.toDouble(),
        top: config.marginTop.toDouble(),
        bottom: config.marginBottom.toDouble(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: config.isLeft ? 70 : 0, right: config.isLeft ? 0 : 70),
            child: CustomPaint(
              painter: TestimonialChatBox(
                isLeft: config.isLeft,
                color: config.backgroundColor != null
                    ? HexColor(config.backgroundColor)
                    : Theme.of(context).primaryColorLight,
                borderRadius: config.borderRadius.toDouble(),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: 10 + config.borderRadius / 2, vertical: 5),
                child: Text(
                  config.testimonial,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: HexColor(config.textColor),
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment:
                config.isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!config.isLeft) ...[
                renderAuthor(context),
                const SizedBox(width: 10),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: config.avatar != null
                      ? FluxImage(
                          imageUrl: config.avatar!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person, size: 30),
                ),
              ),
              if (config.isLeft) ...[
                const SizedBox(width: 10),
                renderAuthor(context),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

class TestimonialChatBox extends CustomPainter {
  final Color color;
  final bool isLeft;
  final double borderRadius;
  TestimonialChatBox(
      {required this.color, this.isLeft = true, this.borderRadius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    Path paintBubbleTail() {
      Path path;
      if (isLeft) {
        path = Path()
          ..addPolygon([
            Offset(0, size.height + 20),
            Offset(size.width / 2, size.height / 2),
            Offset(size.width / 4, borderRadius / 2),
          ], true);
      } else {
        path = Path()
          ..addPolygon([
            Offset(size.width, size.height + 20),
            Offset(size.width / 2, size.height / 2),
            Offset(3 * size.width / 4, borderRadius / 2),
          ], true);
      }

      return path;
    }

    final bubbleBody = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius));
    final bubbleTail = paintBubbleTail();
    canvas.drawRRect(bubbleBody, paint);
    canvas.drawPath(bubbleTail, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
