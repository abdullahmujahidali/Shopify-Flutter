import 'package:flutter/material.dart';

enum TypographyFontStyle { underline, bold, italic, line, none }

enum TypographyTransform { uper, lower, full, normal }

double? toDouble(dynamic value) {
  try {
    if (value == null || value.toString().isEmpty) {
      return 0.0;
    }
    return double.tryParse(value.toString());
  } catch (e) {
    return 0.0;
  }
}

class Story {
  int? layout;
  String? urlImage;
  List<StoryContent>? contents;

  Story({
    this.layout,
    this.urlImage,
    this.contents,
  });

  Story.fromJson(Map<dynamic, dynamic> json) {
    // ignore: avoid_as
    layout = json['layout'] ?? '' as int?;
    urlImage = json['urlImage'] ?? '';
    contents = [];
    if (json['contents'] != null && json['contents'].isNotEmpty) {
      for (final item in json['contents']) {
        contents!.add(StoryContent.fromJson(item));
      }
    }
  }

  Story copy() {
    return Story(
      contents: contents!.map(StoryContent.copyWith).toList(),
      layout: layout,
      urlImage: urlImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'layout': layout ?? '',
      'urlImage': urlImage ?? '',
      'contents': contents != null && contents!.isNotEmpty
          ? contents!.map((content) => content.toJson()).toList()
          : []
    };
  }
}

class StoryContent {
  String? title;
  EdgeInsets? padding;
  StoryLink? link;
  StoryTypography? typography;
  StoryAnimation? animation;
  StorySpacing? spacing;

  StoryContent({
    this.title,
    this.padding,
    this.link,
    this.typography,
    this.animation,
    this.spacing,
  });

  StoryContent.empty() {
    title = 'Text';
    padding = const EdgeInsets.all(0);
    link = StoryLink.createEmpty;
    animation = StoryAnimation.createEmpty;
    spacing = StorySpacing.createEmpty;
    typography = StoryTypography.createEmpty;
  }
  StoryContent.copyWithEmpty({
    String? title,
    EdgeInsets? padding,
    StoryLink? link,
    StoryTypography? typography,
    StoryAnimation? animation,
    StorySpacing? spacing,
  }) {
    this.title = title ?? 'Text';
    this.padding = padding ?? const EdgeInsets.all(0);
    this.link = link ?? StoryLink.createEmpty;
    this.animation = animation ?? StoryAnimation.createEmpty;
    this.spacing = spacing ?? StorySpacing.createEmpty;
    this.typography = typography ?? StoryTypography.createEmpty;
  }

  StoryContent.copyWith(StoryContent? content) {
    // ignore: invalid_null_aware_operator
    title = content?.title ?? 'Text';
    // ignore: invalid_null_aware_operator
    padding = content?.padding ?? const EdgeInsets.all(0);
    // ignore: invalid_null_aware_operator
    link = content?.link ?? StoryLink.createEmpty;
    // ignore: invalid_null_aware_operator
    animation = content?.animation ?? StoryAnimation.createEmpty;
    // ignore: invalid_null_aware_operator
    spacing = content?.spacing ?? StorySpacing.createEmpty;
    // ignore: invalid_null_aware_operator
    typography = content?.typography ?? StoryTypography.createEmpty;
  }

  String? getTitle() {
    if (typography == null || (typography!.transform?.isEmpty ?? true)) {
      return title;
    }

    switch (typography!.transform) {
      case 'lower':
        return title!.toLowerCase();
      case 'uper':
        return toUpperAllFirstLetter(title!);
      case 'full':
        return title!.toUpperCase();
      default:
        return title;
    }
  }

  String toUpperAllFirstLetter(String text) {
    if (text.length <= 1) {
      return text.toUpperCase();
    }
    text = text.toLowerCase();

    final words = text.split(' ');
    final capitalized = words.map((word) {
      final first = word.substring(0, 1).toUpperCase();
      final rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  EdgeInsets? getPadding(double? widthScreen) {
    if (padding == null) {
      return padding;
    }
    return null;
  }

  StoryContent.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'] ?? '';

    if (json['link'] != null) {
      link = StoryLink.fromJson(json['link']);
    }

    if (json['typography'] != null) {
      typography = StoryTypography.fromJson(json['typography']);
    }

    if (json['animation'] != null) {
      animation = StoryAnimation.fromJson(json['animation']);
    }

    if (json['spacing'] != null) {
      spacing = StorySpacing.fromJson(json['spacing']);
    }
    if (json['paddingContent'] != null) {
      padding = EdgeInsets.only(
        top: toDouble(json['paddingContent']['top']) ?? 0.0,
        bottom: toDouble(json['paddingContent']['bottom']) ?? 0.0,
        left: toDouble(json['paddingContent']['left']) ?? 0.0,
        right: toDouble(json['paddingContent']['right']) ?? 0.0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    var paddingMap = {};

    if (padding != null) {
      paddingMap = {
        'top': padding!.top,
        'bottom': padding!.bottom,
        'left': padding!.left,
        'right': padding!.right,
      };
    }
    return {
      'title': title,
      'link': link!.toJson(),
      'typography': typography!.toJson(),
      'animation': animation!.toJson(),
      'spacing': spacing!.toJson(),
      'paddingContent': paddingMap,
    };
  }
}

class StoryLink {
  String? value;
  String? type;
  String? tag;

  StoryLink({this.value, this.type, this.tag});

  bool get isNotEmpty =>
      (value?.isNotEmpty ?? false) && (type?.isNotEmpty ?? false);
// ignore: prefer_constructors_over_static_methods
  static StoryLink get createEmpty => StoryLink(value: '', type: '', tag: '');

  StoryLink.fromJson(Map<dynamic, dynamic> json) {
    value = json['value'] ?? '';
    type = json['type'] ?? '';
    tag = json['tag'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value ?? '',
      'type': type ?? '',
      'tag': tag ?? '',
    };
  }
}

class StoryTypography {
  String? font;
  double? fontSize;
  String? fontStyle;
  String? align;
  String? transform;
  String? color;
  String? weight;

  StoryTypography({
    this.font = 'Roboto',
    this.fontSize = 15.0,
    this.fontStyle = 'normal',
    this.align = 'center',
    this.transform = 'normal',
    this.color = '#FFFFFF',
    this.weight = '400',
  });

// ignore: prefer_constructors_over_static_methods
  static StoryTypography get createEmpty => StoryTypography(
      font: 'Roboto',
      fontSize: 15.0,
      fontStyle: 'normal',
      align: 'center',
      transform: 'normal',
      weight: '400',
      color: '#FFFFFF');

  StoryTypography.fromJson(Map<dynamic, dynamic> json) {
    font = json['font'] ?? 'Roboto';
    // ignore: avoid_as
    fontSize = toDouble(json['fontSize']);
    fontStyle = json['fontStyle'] ?? '';
    align = json['align'] ?? '';
    transform = json['transform'] ?? '';
    color = json['color'] ?? '#FFFFFF';
    weight = json['weight'] ?? '400';
  }

  Map<String, dynamic> toJson() {
    return {
      'font': font ?? 'Roboto',
      'fontSize': fontSize ?? 15.0,
      'fontStyle': fontStyle ?? '',
      'align': align ?? '',
      'transform': transform ?? '',
      'color': color ?? '#FFFFFF',
      'weight': weight ?? '400'
    };
  }

  TextAlign convertStringToAlign() {
    switch (align) {
      case 'center':
        return TextAlign.center;
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  FontStyle convertStringToStyle() {
    switch (fontStyle) {
      case 'italic':
        return FontStyle.italic;
      default:
        return FontStyle.normal;
    }
  }

  TextDecoration convertStringToDecoration() {
    switch (fontStyle) {
      case 'underline':
        return TextDecoration.underline;
      case 'line':
        return TextDecoration.lineThrough;
      default:
        return TextDecoration.none;
    }
  }

  FontWeight convertStringToWeight() {
    switch (fontStyle) {
      case 'bold':
        return FontWeight.bold;
      default:
        return FontWeight.normal;
    }
  }

  TypographyTransform convertStringToTransform() {
    switch (transform) {
      case 'lower':
        return TypographyTransform.lower;
      case 'uper':
        return TypographyTransform.uper;
      case 'full':
        return TypographyTransform.full;
      default:
        return TypographyTransform.normal;
    }
  }

  void updateFontStyle(TypographyFontStyle style) {
    switch (style) {
      case TypographyFontStyle.underline:
        fontStyle = 'underline';
        break;
      case TypographyFontStyle.bold:
        fontStyle = 'bold';
        break;
      case TypographyFontStyle.italic:
        fontStyle = 'italic';
        break;
      case TypographyFontStyle.line:
        fontStyle = 'line';
        break;
      default:
        fontStyle = 'none';
    }
  }

  void updateFontColor(fontColor) {
    color = fontColor;
  }

  TypographyFontStyle getFontStyle() {
    switch (fontStyle) {
      case 'underline':
        return TypographyFontStyle.underline;
      case 'bold':
        return TypographyFontStyle.bold;
      case 'italic':
        return TypographyFontStyle.italic;
      case 'line':
        return TypographyFontStyle.line;
      default:
        return TypographyFontStyle.none;
    }
  }

  void updateAlign(TextAlign alg) {
    switch (alg) {
      case TextAlign.center:
        align = 'center';
        break;
      case TextAlign.right:
        align = 'right';
        break;
      case TextAlign.justify:
        align = 'justify';
        break;
      default:
        align = 'left';
    }
  }

  void updateTransform(TypographyTransform transf) {
    switch (transf) {
      case TypographyTransform.lower:
        transform = 'lower';
        break;
      case TypographyTransform.uper:
        transform = 'uper';
        break;
      default:
        transform = 'full';
    }
  }

  static String convertAlignToString(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return 'center';
      case TextAlign.left:
        return 'left';
      case TextAlign.right:
        return 'right';
      case TextAlign.justify:
        return 'justify';
      default:
        return 'left';
    }
  }
}

class StoryAnimation {
  String? type;
  int? milliseconds;
  int? delaySecond;

  StoryAnimation({
    this.type,
    this.milliseconds,
    this.delaySecond,
  });
  // ignore: prefer_constructors_over_static_methods
  static StoryAnimation get createEmpty =>
      StoryAnimation(type: '', milliseconds: 300, delaySecond: 0);
  StoryAnimation.fromJson(Map<dynamic, dynamic> json) {
    type = json['type'] ?? '';
    milliseconds = json['milliseconds'] ?? 300;
    delaySecond = json['delaySecond'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type ?? '',
      'milliseconds': milliseconds ?? 300,
      'delaySecond': delaySecond ?? 0,
    };
  }
}

class StorySpacing {
  EdgeInsets? padding;
  EdgeInsets? margin;

  StorySpacing({
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
  });

// ignore: prefer_constructors_over_static_methods
  static StorySpacing get createEmpty => StorySpacing(
      padding: const EdgeInsets.all(0.0), margin: const EdgeInsets.all(0.0));

  StorySpacing.fromJson(Map<dynamic, dynamic> json) {
    if (json['padding'] != null) {
      padding = EdgeInsets.only(
        top: toDouble(json['padding']['top']) ?? 0.0,
        bottom: toDouble(json['padding']['bottom']) ?? 0.0,
        left: toDouble(json['padding']['left']) ?? 0.0,
        right: toDouble(json['padding']['right']) ?? 0.0,
      );
    }

    if (json['margin'] != null) {
      margin = EdgeInsets.only(
        top: toDouble(json['margin']['top']) ?? 0.0,
        bottom: toDouble(json['margin']['bottom']) ?? 0.0,
        left: toDouble(json['margin']['left']) ?? 0.0,
        right: toDouble(json['margin']['right']) ?? 0.0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    var paddingMap = {};

    if (padding != null) {
      paddingMap = {
        'top': padding!.top,
        'bottom': padding!.bottom,
        'left': padding!.left,
        'right': padding!.right,
      };
    }

    var result = {};
    if (margin != null) {
      result = {
        'top': margin!.top,
        'bottom': margin!.bottom,
        'left': margin!.left,
        'right': margin!.right,
      };
    }
    return {'padding': paddingMap, 'margin': result};
  }
}
