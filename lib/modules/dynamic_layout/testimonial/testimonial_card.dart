import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../../../widgets/common/flux_image.dart';
import '../../../widgets/common/start_rating.dart';
import '../config/testimonial_config.dart';

class TestimonialCard extends StatelessWidget {
  final TestimonialConfig config;
  const TestimonialCard({required this.config});

  Widget renderAuthor(context) {
    return Column(
      children: [
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
        const SizedBox(height: 5),
        if (config.name != null)
          Text(
            config.name.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        if (config.major != null) ...[
          const SizedBox(height: 5),
          Text(
            config.major.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          )
        ],
        if (config.rating != null) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              const Spacer(),
              SmoothStarRating(
                size: 10,
                rating: config.rating?.toDouble(),
              ),
              const Spacer(),
            ],
          )
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var backgroundMargin = 50.0;
    if (!config.authorInTop) {
      backgroundMargin += config.name != null ? 15 : 0;
      backgroundMargin += config.major != null ? 20 : 0;
      backgroundMargin += config.rating != null ? 15 : 0;
    }

    return Container(
      margin: EdgeInsets.only(
        left: config.marginLeft.toDouble(),
        right: config.marginRight.toDouble(),
        top: config.marginTop.toDouble(),
        bottom: config.marginBottom.toDouble(),
      ),
      decoration: BoxDecoration(
          border: config.borderWidth > 0
              ? Border.all(
                  color: Colors.grey,
                  width: config.borderWidth.toDouble(),
                )
              : null,
          borderRadius: BorderRadius.circular(config.borderRadius.toDouble()),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            if (config.boxShadowConfig != null)
              BoxShadow(
                color: Colors.grey
                    .withOpacity(config.boxShadowConfig!.colorOpacity),
                offset: Offset(
                    config.boxShadowConfig!.x, config.boxShadowConfig!.y),
                blurRadius: config.boxShadowConfig!.blurRadius,
                spreadRadius: config.boxShadowConfig!.spreadRadius,
              ),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(config.borderRadius.toDouble()),
        child: CustomPaint(
          painter: TestimonialCardBox(
            color: config.backgroundColor != null
                ? HexColor(config.backgroundColor)
                : Theme.of(context).primaryColorLight,
            authorInTop: config.authorInTop,
            backgroundMargin: backgroundMargin,
            radius:
                config.borderRadius.toDouble() - config.borderWidth.toDouble(),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                if (config.authorInTop) ...[
                  renderAuthor(context),
                  const SizedBox(height: 20)
                ],
                Padding(
                  padding: EdgeInsets.only(
                    left: config.borderRadius.toDouble() / 4,
                    right: config.borderRadius.toDouble() / 4,
                    top: config.authorInTop
                        ? 0.0
                        : config.borderRadius.toDouble() / 4,
                    bottom: config.authorInTop
                        ? config.borderRadius.toDouble() / 4
                        : 0.0,
                  ),
                  child: Text(
                    config.testimonial,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: HexColor(config.textColor)),
                  ),
                ),
                if (!config.authorInTop) ...[
                  const SizedBox(height: 20),
                  renderAuthor(context)
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestimonialCardBox extends CustomPainter {
  final Color color;
  final bool authorInTop;
  final double backgroundMargin;
  final double radius;
  TestimonialCardBox({
    required this.color,
    this.authorInTop = true,
    this.backgroundMargin = 40,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final bubbleBody = RRect.fromLTRBAndCorners(
      0,
      authorInTop ? backgroundMargin : 0,
      size.width,
      size.height - (authorInTop ? 0 : backgroundMargin),
      topLeft: authorInTop ? Radius.zero : Radius.circular(radius),
      topRight: authorInTop ? Radius.zero : Radius.circular(radius),
      bottomLeft: authorInTop ? Radius.circular(radius) : Radius.zero,
      bottomRight: authorInTop ? Radius.circular(radius) : Radius.zero,
    );
    canvas.drawRRect(bubbleBody, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
