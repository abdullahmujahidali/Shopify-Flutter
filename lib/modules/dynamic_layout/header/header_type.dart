import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../config/header_config.dart';

class HeaderType extends StatelessWidget {
  final HeaderConfig config;

  const HeaderType({required this.config});

  @override
  Widget build(BuildContext context) {
    var fontSize = config.fontSize;
    var textOpacity = config.textOpacity;
    var fontWeight = config.fontWeight;
    var textColor = config.textColor != null
        ? HexColor(config.textColor)
        : Theme.of(context).colorScheme.secondary;

    var textStyle = TextStyle(
      fontSize: fontSize.toDouble(),
      fontWeight: Tools.getFontWeight(fontWeight.toString()),
      color: textColor.withOpacity(textOpacity.toDouble()),
    );

    Widget renderAnimatedText({required List<AnimatedText> animatedTexts}) {
       return AnimatedTextItem(
          title: config.title,
          textStyle: textStyle,
          minWidth: config.minWidth.toDouble(),
          animatedTexts: animatedTexts,
        );
    }

    switch (config.type) {
      case 'rotate':
        return renderAnimatedText(
          animatedTexts: [
            for (var name in config.rotate)
              RotateAnimatedText(
                name,
                textStyle: textStyle,
              ),
          ]
        );
      case 'fade':
        return renderAnimatedText(
          animatedTexts: [
            for (var name in config.rotate)
              FadeAnimatedText(
                name,
                textStyle: textStyle,
              ),
          ],
        );
      case 'typer':
        return renderAnimatedText(
          animatedTexts: [
            for (var name in config.rotate)
              TyperAnimatedText(
                name,
                textStyle: textStyle,
              ),
          ],
        );
      case 'typewriter':
        return renderAnimatedText(
          animatedTexts: [
            for (var name in config.rotate)
              TypewriterAnimatedText(
                name,
                textStyle: textStyle,
              ),
          ],
        );
      case 'scale':
        return renderAnimatedText(
          animatedTexts: [
            for (var name in config.rotate)
              ScaleAnimatedText(
                name,
                textStyle: textStyle,
              ),
          ],
        );
      case 'color':
        return renderAnimatedText(
          animatedTexts: [
            for (var name in config.rotate)
              ColorizeAnimatedText(
                name,
                textStyle: textStyle,
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.yellow,
                  Colors.red,
                ],
              ),
          ],
        );
      case 'static':
      default:
        return config.title != null && config.title.toString().isNotEmpty
            ? FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  config.title ?? '',
                  style: textStyle,
                  maxLines: 3,
                ),
              )
            : const SizedBox();
    }
  }
}

class AnimatedTextItem extends StatelessWidget {
  final String? title;
  final TextStyle? textStyle;
  final double minWidth;
  final List<AnimatedText> animatedTexts;

  const AnimatedTextItem({
    this.title,
    this.textStyle,
    this.minWidth = 0.0,
    required this.animatedTexts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.isNotEmpty ?? false) ...[
            Text(
              title!,
              style: textStyle ?? const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(width: 10.0),
          ],
          AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: animatedTexts,
            repeatForever: true,
          ),
        ],
      ),
    );
  }
}
