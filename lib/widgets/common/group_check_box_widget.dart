import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../backdrop/filters/container_filter.dart';

class GroupCheckBoxWidget<T> extends StatefulWidget {
  const GroupCheckBoxWidget({
    Key? key,
    this.onChanged,
    this.defaultValue,
    required this.values,
    this.numberOfRow = 2,
    this.mustSelectAtLeastOneItem = false,
    this.childAspectRatio = 1.0,
  })  :
        // assert(
        //   defaultValue == null ||
        //       (values.map((e) => e.value).contains(defaultValue)),
        //   'defaultValue must be in values',
        // ),
        assert(
          mustSelectAtLeastOneItem == false || defaultValue != null,
          'mustSelectAtLeastOneItem must be false if defaultValue is null',
        ),
        assert(numberOfRow > 0, 'numberOfRow must be greater than 0'),
        assert(values.length > 1, 'values must be greater than 1'),
        super(key: key);

  final ValueChanged<GroupCheckBoxItem<T>?>? onChanged;
  final T? defaultValue;
  final Set<GroupCheckBoxItem<T>> values;
  final int numberOfRow;
  final bool mustSelectAtLeastOneItem;
  final double childAspectRatio;

  @override
  State<GroupCheckBoxWidget<T>> createState() => _GroupCheckBoxWidgetState();
}

class _GroupCheckBoxWidgetState<T> extends State<GroupCheckBoxWidget<T>> {
  GroupCheckBoxItem<T>? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.values
        .firstWhereOrNull((item) => item.value == widget.defaultValue);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.values.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.numberOfRow,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final item = widget.values.elementAt(index);
        final currentItemIsSelected = _selectedItem == item;
        return ContainerFilter(
          // margin: const EdgeInsets.all(5.0),
          isSelected: currentItemIsSelected,
          text: item.title,
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                _selectedItem = item;
              } else {
                if (!widget.mustSelectAtLeastOneItem) {
                  _selectedItem = null;
                }
              }
            });
            widget.onChanged?.call(_selectedItem);
          },
        );
      },
    );
  }
}

class GroupCheckBoxItem<T> {
  const GroupCheckBoxItem({
    required this.value,
    required this.title,
  });

  final T value;
  final String title;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupCheckBoxItem &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          title == other.title;

  @override
  int get hashCode => value.hashCode ^ title.hashCode;

  GroupCheckBoxItem copyWith({
    T? value,
    String? title,
  }) {
    return GroupCheckBoxItem(
      value: value ?? this.value,
      title: title ?? this.title,
    );
  }
}
