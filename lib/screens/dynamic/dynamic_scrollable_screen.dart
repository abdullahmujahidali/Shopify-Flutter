import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/app_model.dart';
import '../../modules/dynamic_layout/background/background.dart';
import '../../modules/dynamic_layout/config/app_config.dart';
import '../../widgets/home/index.dart';
import '../base_screen.dart';
import '../common/app_bar_mixin.dart';

class DynamicScrollableScreen extends StatefulWidget {
  final String? previewKey;
  final List<TabBarMenuConfig> data;

  const DynamicScrollableScreen({required this.data, this.previewKey});

  @override
  State<StatefulWidget> createState() {
    return DynamicScrollableScreenState();
  }
}

class DynamicScrollableScreenState extends BaseScreen<DynamicScrollableScreen>
    with AutomaticKeepAliveClientMixin<DynamicScrollableScreen>, AppBarMixin {
  static BuildContext? homeContext;

  static late BuildContext loadingContext;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  final ScrollController _scrollController = ScrollController();

  bool get emptyHorizontal =>
      true; // widget.configs['HorizonLayout']?.isEmpty ?? true;

  @override
  bool get wantKeepAlive => true;

  StreamSubscription? _sub;
  int? itemId;
  late final ValueNotifier<double> _offsetNotifier =
      ValueNotifier(1 - _initialSize);

  double get _initialSize => 0.6;

  double get _minSize => 0.4;

  @override
  void dispose() {
    printLog('[Home] dispose');
    _sheetController.removeListener(_sheetSizeListener);
    _sub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    screenScrollController = _scrollController;
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    homeContext = context;
    _sheetController.addListener(_sheetSizeListener);
  }

  void _sheetSizeListener() {
    _offsetNotifier.value = 1 - _sheetController.size;
  }

  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        loadingContext = context;
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.all(50.0),
            child: kLoadingWidget(context),
          ),
        );
      },
    );
  }

  static void hideLoading() {
    Navigator.of(loadingContext).pop();
  }

  Widget renderLayout({
    required int index,
    required AppConfig appConfig,
    ScrollController? scrollController,
    bool showNewAppBar = false,
  }) {
    var configs = widget.data[index].jsonData['configs'];
    var pageConfig = AppConfig.fromJson(configs);

    var isStickyHeader = appConfig.settings.stickyHeader;

    if (configs == null) {
      return const SizedBox();
    }

    return Stack(
      children: [
        if (configs['Background'] != null)
          HomeBackground(config: pageConfig.background),

        PrimaryScrollController(
          controller: ScrollController(),
          child: HomeLayout(
            isPinAppBar: isStickyHeader,
            enableRefresh: false,
            isShowAppbar: emptyHorizontal
                ? false
                : configs['HorizonLayout'][0]['layout'] == 'logo',
            showNewAppBar: showNewAppBar,
            configs: configs,
            scrollController: scrollController,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    printLog('[Dynamic Screen] build');
    return Selector<AppModel, AppConfig?>(
      selector: (_, model) => model.appConfig,
      builder: (context, appConfig, child) {
        if (appConfig == null) {
          return kLoadingWidget(context);
        }

        if (widget.data.isEmpty) {
          return const SizedBox();
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            fit: StackFit.expand,
            children: [
              ValueListenableBuilder<double>(
                valueListenable: _offsetNotifier,
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: max(value, 0.0),
                    child: renderLayout(
                      index: 0,
                      appConfig: appConfig,
                      showNewAppBar: appConfig.appBar
                              ?.shouldShowOn(RouteList.scrollable) ??
                          false,
                      scrollController: _scrollController,
                    ),
                  );
                },
              ),
              DraggableScrollableSheet(
                initialChildSize: _initialSize,
                minChildSize: _minSize,
                controller: _sheetController,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: const Offset(0, -2),
                        ),
                      ],
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: widget.data.length == 2
                        ? renderLayout(
                            index: 1,
                            appConfig: appConfig,
                            scrollController: scrollController,
                          )
                        : const SizedBox(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
