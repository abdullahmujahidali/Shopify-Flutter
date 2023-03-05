import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../../../widgets/common/index.dart';
import '../index.dart';

class ButtonLayout extends StatelessWidget {
  final ButtonConfig config;
  const ButtonLayout({required this.config, Key? key}) : super(key: key);

  Widget renderButtonItem(BuildContext context, ButtonItemConfig item,
      {double? maxWidth}) {
    var widget;
    if (item.image != null) {
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(item.borderRadius.toDouble()),
        child: FluxImage(
          imageUrl: item.image!,
          width: maxWidth ?? item.width.toDouble(),
          height: item.height.toDouble(),
        ),
      );
    } else {
      widget = Container(
        width: maxWidth ?? item.width.toDouble(),
        height: item.height.toDouble(),
        decoration: BoxDecoration(
          color: item.backgroundColor != null
              ? HexColor(item.backgroundColor)
              : null,
          borderRadius: BorderRadius.circular(item.borderRadius.toDouble()),
        ),
        child: Center(
          child: Text(
            item.text ?? '',
            style: TextStyle(
              color: item.textColor != null ? HexColor(item.textColor) : null,
              fontSize: item.textFontSize.toDouble(),
            ),
          ),
        ),
      );
    }
    return InkWell(
      onTap: () => NavigateTools.onTapNavigateOptions(
          context: context, config: item.navigator),
      child: widget,
    );
  }

  Widget renderItem(BuildContext context, ButtonItemConfig item) {
    if (item.useMaxWidth) {
      return Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.only(
                left: item.marginLeft.toDouble(),
                right: item.marginRight.toDouble(),
              ),
              child: Center(
                child: renderButtonItem(context, item,
                    maxWidth: constraints.maxWidth),
              ),
            );
          },
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(
        left: item.marginLeft.toDouble(),
        right: item.marginRight.toDouble(),
      ),
      child: renderButtonItem(context, item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        top: config.marginTop.toDouble(),
        bottom: config.marginBottom.toDouble(),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Tools.getAlignment(config.alignment),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(config.items.length,
                  (index) => renderItem(context, config.items[index])),
            ),
          ),
        ],
      ),
    );
  }
}
