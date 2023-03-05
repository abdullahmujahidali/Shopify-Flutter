import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'package:flutter/cupertino.dart' show CupertinoNavigationBar;

class CommonScaffold extends StatelessWidget {
  final children;
  final title;
  final middle;
  final trailing;
  final leading;
  final navigationBar;
  final onRefresh;
  final controller;
  const CommonScaffold({
    this.children,
    this.leading,
    this.middle,
    this.navigationBar,
    this.trailing,
    this.title,
    this.controller,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (navigationBar != null) {
      return Material(
        child: CupertinoPageScaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          navigationBar: navigationBar,
          child: children,
        ),
      );
    }

    if (onRefresh == null) {
      return Material(
        child: CupertinoPageScaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: CustomScrollView(
            controller: controller,
            cacheExtent: 2000.0,
            slivers: [
              CupertinoSliverNavigationBar(
                heroTag: 'key-$title',
                backgroundColor: Theme.of(context).colorScheme.background,
                middle: middle,
                largeTitle: title != null
                    ? Text(
                        title,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : const SizedBox(),
                leading: leading,
                trailing: trailing,
                border: null,
              ),
              SliverList(
                delegate: SliverChildListDelegate(children),
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            controller: controller,
            cacheExtent: 2000.0,
            slivers: [
              CupertinoSliverNavigationBar(
                heroTag: 'key-$title',
                backgroundColor: Theme.of(context).colorScheme.background,
                middle: middle,
                largeTitle: title != null
                    ? Text(
                        title,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : const SizedBox(),
                leading: leading,
                trailing: trailing,
                border: null,
              ),
              SliverList(
                delegate: SliverChildListDelegate(children),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
