import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import 'package:image_fade/image_fade.dart';
import 'package:lottie/lottie.dart';

import '../../common/constants.dart';

class FluxImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final String? package;
  final Widget? errorWidget;
  final Alignment alignment;
  final bool useExtendedImage;

  const FluxImage({
    required this.imageUrl,
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.package,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.useExtendedImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageProxy = '';
    var isSvgImage = imageUrl.split('.').last == 'svg';
    var isLottieImage = imageUrl.split('.').last == 'json';

    if (imageUrl.isEmpty) {
      return const SizedBox();
    }

    final cacheWidth = width != null && (width ?? 0) > 0
        ? (width! * 2.5).toInt()
        : kCacheImageWidth;

    if (!imageUrl.contains('http')) {
      if (isSvgImage) {
        return SvgPicture.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: color,
          alignment: alignment,
          package: package,
        );
      }

      if (isLottieImage) {
        return Lottie.asset(
          imageUrl,
          repeat: true,
          reverse: true,
          animate: true,
          width: width,
          height: height,
          alignment: alignment,
          fit: fit ?? BoxFit.contain,
        );
      }

      if (useExtendedImage) {
        return ExtendedImage.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          color: color,
          package: package,
          alignment: alignment,
          cacheWidth: kIsWeb ? null : cacheWidth,
        );
      } else {
        return Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          color: color,
          package: package,
          alignment: alignment,
          cacheWidth: kIsWeb ? null : cacheWidth,
        );
      }
    }

    if (kIsWeb) {
      imageProxy = '$kImageProxy${width}x,q30/';
      if (kImageProxy.isEmpty) {
        /// this image proxy is use for demo purpose, please make your own one
        imageProxy = 'https://cors.mstore.io/';
      }
    }

    if (isSvgImage) {
      return SvgPicture.network(
        '$imageProxy$imageUrl',
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
        alignment: alignment,
      );
    }

    if (isLottieImage) {
      return Lottie.network(
        imageUrl,
        repeat: true,
        reverse: true,
        animate: true,
        width: width,
        height: height,
        alignment: alignment,
        fit: fit ?? BoxFit.contain,
      );
    }

    if (useExtendedImage) {
      return ExtendedImage.network(
        '$imageProxy$imageUrl',
        width: width,
        height: height,
        fit: fit,
        color: color,
        cache: true,
        alignment: alignment,
        cacheWidth: cacheWidth,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.completed:
              return state.completedWidget;
            // return ImageFade(
            //   image: state.imageProvider,
            //   width: width,
            //   height: height,
            //   fit: fit ?? BoxFit.scaleDown,
            //   alignment: alignment,
            //   duration: const Duration(milliseconds: 250),
            // );
            case LoadState.failed:
              return errorWidget ?? const SizedBox();
            case LoadState.loading:
            default:
              return const SizedBox();
          }
        },
      );
    } else {
      return Image.network(
        '$imageProxy$imageUrl',
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        cacheWidth: cacheWidth,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? const SizedBox();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const SizedBox();
        },
      );
    }
  }
}
