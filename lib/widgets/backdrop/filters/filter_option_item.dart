import 'package:flutter/material.dart';

import 'container_filter.dart';

class FilterOptionItem extends StatelessWidget {
  final bool enabled;
  final Function? onTap;
  final bool? selected;
  final String? title;
  final bool isValid;

  const FilterOptionItem({
    Key? key,
    this.enabled = true,
    this.onTap,
    this.selected,
    this.title,
    this.isValid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (enabled == true && onTap != null) {
          onTap!();
        }
      },
      child: ContainerFilter(
        margin: const EdgeInsets.all(5.0),
        isSelected: selected == true && isValid == true,
        text: title ?? '',
      ),
    );
  }
}
