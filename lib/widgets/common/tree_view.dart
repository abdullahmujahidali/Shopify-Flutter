import 'package:flutter/material.dart';

typedef ParentSelectChanged = void Function(bool isSelected);

/// # Tree View
///
/// Creates a tree view widget. The widget is a List View with a [List] of
/// [Parent] widgets. The [TreeView] is nested inside a [Scrollbar] if the
/// [TreeView.hasScrollBar] property is true.
class TreeView extends StatelessWidget {
  final List<Parent> parentList;
  final bool hasScrollBar;

  const TreeView({
    this.parentList = const <Parent>[],
    this.hasScrollBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return hasScrollBar ? Scrollbar(child: _getTreeList()) : _getTreeList();
  }

  Widget _getTreeList() {
    return Column(children: <Widget>[for (var item in parentList) item]);
  }
}

/// # Parent widget
///
/// The [Parent] widget holds the [Parent.parent] widget and
/// [Parent.childList] which is a [List] of child widgets.
///
/// The [Parent] widget is wrapped around a [Column]. The [Parent.childList]
/// is collapsed by default. When clicked the child widget is expanded.
class Parent extends StatefulWidget {
  final Widget parent;
  final ChildList childList;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final ParentSelectChanged? callback;

  const Parent({
    required this.parent,
    required this.childList,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.callback,
    key,
  }) : super(key: key);

  @override
  ParentState createState() => ParentState();
}

class ParentState extends State<Parent> {
  final ValueNotifier<bool> _isSelected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: widget.mainAxisSize,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: <Widget>[
        InkWell(
          onTap: expand,
          child: widget.parent,
        ),
        _getChild(),
      ],
    );
  }

  void expand() {
    if (widget.callback != null) widget.callback!(_isSelected.value);
    _isSelected.value = _toggleBool(_isSelected.value);
  }

  bool _toggleBool(bool b) {
    return b ? false : true;
  }

  Widget _getChild() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSelected,
      builder: (context, value, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SizeTransition(sizeFactor: animation, child: child);
          },
          child: value ? widget.childList : null,
        );
      },
    );
  }
}

/// # ChildList widget
///
/// The [ChildList] widget holds a [List] of widget which will be displayed as
/// children of the [Parent] widget
class ChildList extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const ChildList({
    this.children = const <Widget>[],
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}
