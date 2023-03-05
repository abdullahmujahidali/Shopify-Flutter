import 'package:flutter/material.dart';

class FilterLabel extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Widget? leading;
  final Function()? onTap;

  const FilterLabel({
    Key? key,
    required this.label,
    this.onTap,
    this.icon,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        constraints: const BoxConstraints(minWidth: 50),
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 4),
            ],
            Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      textBaseline: TextBaseline.ideographic,
                    ),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              icon!,
            ]
          ],
        ),
      ),
    );
  }
}
