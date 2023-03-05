import 'dart:async';

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
import 'dynamic_menu_widget.dart';

class DynamicTabMenuScreen extends StatefulWidget {
  final String? previewKey;
  final List<TabBarMenuConfig> data;

  const DynamicTabMenuScreen({required this.data, this.previewKey});

  @override
  State<StatefulWidget> createState() {
    return DynamicScreenState();
  }
}

class DynamicScreenState extends BaseScreen<DynamicTabMenuScreen>
    with AutomaticKeepAliveClientMixin<DynamicTabMenuScreen>, AppBarMixin {
  static BuildContext? homeContext;

  static late BuildContext loadingContext;

  bool get emptyHorizontal =>
      true; // widget.configs['HorizonLayout']?.isEmpty ?? true;

  @override
  bool get wantKeepAlive => true;

  StreamSubscription? _sub;
  int? itemId;

  @override
  void dispose() {
    printLog('[Home] dispose');
    _sub?.cancel();
    super.dispose();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    homeContext = context;
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

        var isStickyHeader = appConfig.settings.stickyHeader;
        return DefaultTabController(
          length: widget.data.length,
          child: SafeArea(
            bottom: false,
            child: renderScaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              routeName: RouteList.tabMenu,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    DynamicMenuWidget(data: widget.data),
                  ];
                },
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    widget.data.length,
                    (index) {
                      var configs = widget.data[index].jsonData['configs'];
                      var pageConfig = AppConfig.fromJson(configs);

                      return Stack(
                        children: [
                          if (pageConfig.background != null)
                            HomeBackground(config: pageConfig.background),
                          PrimaryScrollController(
                            controller: ScrollController(),
                            child: HomeLayout(
                              isPinAppBar: isStickyHeader,
                              isShowAppbar: emptyHorizontal
                                  ? false
                                  : configs['HorizonLayout'][0]['layout'] ==
                                      'logo',
                              showNewAppBar: false,
                              configs: configs,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
