import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' show S;
import '../../models/paging_data_base.dart';
import 'loading_widget.dart';
import 'paging_mixin.dart';
import 'refresh_scroll_physics.dart';
import 'sliver_empty_data.dart';

typedef PagingWidgetBuilder<T> = Widget Function(
    BuildContext, T entity, int index);

typedef SelectorData<M, T> = List<T> Function(M model);

class PagingList<M extends PagingDataBase<T>, T> extends StatefulWidget {
  final PagingWidgetBuilder<T>? itemBuilder;

  /// The widget will show when the list is empty or when the list is loading
  /// if [null] it will show a [LoadingWidget]
  final Widget? loadingWidget;

  /// The number of widgets loading to build when the list is first built.
  final int lengthLoadingWidget;

  /// The callback when the list is pull to refresh
  final Function? onRefresh;

  /// The widget of the head of the list
  final Widget? header;

  /// If it is true (the default) the model will auto load data when the widget
  /// is created
  final bool autoInitData;
  final ScrollController? scrollController;

  /// If true the model will get more data when extent scroll
  /// less than [kExtentInfinite], that means the loading widget does not show
  /// If false the model will get more data when extent scroll
  /// less than [kExtentDefault]
  final bool infiniteMode;

  final bool showScrollToTopButton;

  final SelectorData<M, T>? selectorData;

  final bool allowPullToRefresh;

  const PagingList({
    this.itemBuilder,
    this.loadingWidget,
    this.lengthLoadingWidget = 1,
    this.onRefresh,
    this.header,
    this.autoInitData = true,
    this.scrollController,
    this.infiniteMode = false,
    this.showScrollToTopButton = true,
    this.selectorData,
    this.allowPullToRefresh = true,
  }) : assert(lengthLoadingWidget > 0);

  @override
  State<PagingList<M, T>> createState() => _PagingListState();
}

class _PagingListState<M extends PagingDataBase<T>, T>
    extends State<PagingList<M, T>> with PagingMixin {
  Widget get loadingWidget => widget.loadingWidget ?? const LoadingWidget();

  M get model => Provider.of<M>(context, listen: false);

  List<T> get data => widget.selectorData?.call(model) ?? model.data;

  @override
  late final ScrollController scrollController =
      widget.scrollController ?? ScrollController();

  @override
  Future<void> getData() => model.getData();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        if (widget.autoInitData) {
          model.getData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<M>(
      builder: (context, model, _) {
        return Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              physics: const RefreshScrollPhysics(),
              slivers: [
                if (widget.allowPullToRefresh)
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      await model.refresh();
                      widget.onRefresh?.call();
                    },
                  ),
                if (widget.header != null)
                  SliverToBoxAdapter(child: widget.header),
                model.isFirstLoad
                    ? _buildInitBody()
                    : data.isEmpty
                        ? const SliverEmptyData()
                        : _body,
                SliverToBoxAdapter(
                  child: Builder(
                    builder: (context) {
                      var showLoadingWidget = false;
                      final noMoreData = !model.hasNext;

                      if (scrollController.hasClients) {
                        showLoadingWidget = model.isLoadMore &&
                            scrollController.position.extentBefore > 200;
                      }

                      return AnimatedSwitcher(
                        transitionBuilder: (child, animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: const Offset(0.0, 0.0),
                          ).animate(animation);
                          final sizeAnimation = Tween<double>(
                            begin: 0.0,
                            end: 1.2,
                          ).animate(animation);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: SizeTransition(
                              sizeFactor: sizeAnimation,
                              axisAlignment: -1.75,
                              axis: Axis.vertical,
                              child: child,
                            ),
                          );
                        },
                        duration: const Duration(milliseconds: 250),
                        reverseDuration: const Duration(milliseconds: 350),
                        child: model.isLoadMore && noMoreData
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(S.of(context).noData),
                                ),
                              )
                            : model.isLoadMore && showLoadingWidget
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 8.0,
                                      top: 10.0,
                                    ),
                                    child: loadingWidget,
                                  )
                                : const SizedBox(),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (widget.showScrollToTopButton) scrollToTopButton,
          ],
        );
      },
    );
  }

  Widget get _body => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return widget.itemBuilder!(
              context,
              data[index],
              index,
            );
          },
          childCount: data.length,
        ),
      );

  Widget _buildInitBody() {
    return widget.loadingWidget != null
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => loadingWidget,
              childCount: widget.lengthLoadingWidget,
            ),
          )
        : SliverFillRemaining(
            child: widget.loadingWidget,
          );
  }
}
