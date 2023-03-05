import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';

class ProductImageThumbnail extends StatelessWidget {
  final List<String> itemList;
  final Function({required int index, bool? fullScreen}) onSelect;
  final int selectIndex;

  const ProductImageThumbnail({
    required this.itemList,
    required this.onSelect,
    this.selectIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    var height = 50.0;
    if (itemList.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width - 95,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 8),
            for (var i = 0; i < itemList.length; i++)
              GestureDetector(
                onDoubleTap: () => onSelect(index: i, fullScreen: true),
                onLongPress: () => onSelect(index: i, fullScreen: true),
                onTap: () => onSelect(index: i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(1),
                  margin: const EdgeInsets.only(right: 10, top: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.background,
                    border: Border.all(
                      color: selectIndex == i
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ImageResize(
                    url: itemList[i],
                    height: height * (kIsWeb ? 1.2 : 1),
                    width: height,
                    isResize: true,
                    fit: BoxFit.cover,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
