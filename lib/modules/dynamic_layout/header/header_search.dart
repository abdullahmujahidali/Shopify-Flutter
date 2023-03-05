import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../config/header_config.dart';
import '../helper/helper.dart';

class HeaderSearch extends StatelessWidget {
  final HeaderConfig config;
  final Function? onSearch;

  const HeaderSearch({required this.config, this.onSearch, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = config.title ?? '';

    return Container(
      margin: EdgeInsets.only(
        top: config.marginTop.toDouble(),
        left: config.marginLeft.toDouble(),
        right: config.marginRight.toDouble(),
        bottom: config.marginBottom.toDouble(),
      ),
      child: SafeArea(
        bottom: false,
        top: config.isSafeArea == true,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            config.radius?.toDouble() ?? 30.0,
          ),
          onTap: () => onSearch!(),
          child: Container(
            padding: EdgeInsets.only(
              top: config.paddingTop.toDouble(),
              left: config.paddingLeft.toDouble(),
              right: config.paddingRight.toDouble(),
              bottom: config.paddingBottom.toDouble(),
            ),
            height: config.height.toDouble(),
            decoration: BoxDecoration(
              color: config.backgroundColor != null
                  ? HexColor(config.backgroundColor)
                  : (config.usePrimaryColor
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).colorScheme.background),
              boxShadow: [
                if (config.boxShadow != null)
                  BoxShadow(
                    blurRadius: config.boxShadow!.blurRadius,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(config.boxShadow!.colorOpacity),
                    spreadRadius: config.boxShadow!.spreadRadius,
                    offset: Offset(config.boxShadow!.x, config.boxShadow!.y),
                  )
              ],
              borderRadius: BorderRadius.circular(
                config.radius?.toDouble() ?? 30.0,
              ),
              border: Border.all(
                width: 1.0,
                color: config.borderInput
                    ? Colors.black.withOpacity(0.05)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: <Widget>[
                const Icon(CupertinoIcons.search, size: 24),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Helper.formatDouble(config.fontSize),
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(
                              Helper.formatDouble(config.textOpacity)!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
