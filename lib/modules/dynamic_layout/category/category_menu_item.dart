import 'package:flutter/material.dart';

class CategoryMenuItem extends StatelessWidget {
  final String? name;
  final double fontSize;
  final bool? isSelected;
  final Function? onTap;

  const CategoryMenuItem({
    this.name,
    required this.fontSize,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Column(
        children: [
          Text(
            name ?? '',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: fontSize,
                ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          AnimatedContainer(
            decoration: BoxDecoration(
              color: (isSelected ?? false)
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(2.0),
            ),
            margin: const EdgeInsets.only(
              top: 4.0,
            ),
            height: 4.0,
            width: 4.0,
            duration: const Duration(
              milliseconds: 400,
            ),
          ),
        ],
      ),
    );
  }
}
