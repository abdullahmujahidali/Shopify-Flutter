import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../models/index.dart';
import '../modules/dynamic_layout/index.dart';
import '../routes/route.dart';

class PageTabScreen extends StatelessWidget {
  final TabBarMenuConfig config;
  const PageTabScreen(this.config);

  @override
  Widget build(BuildContext context) {
    var appModel = Provider.of<AppModel>(context, listen: false);
    var tabData = appModel.appConfig!.tabBar;
    var groupTabData = tabData.where((e) => e.groupLayout == true).toList();
    var initialRoute = config.layout;
    var routeData = initialRoute == RouteList.tabMenu ||
              initialRoute == RouteList.scrollable
          ? groupTabData
          : config;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          config.label ?? config.menuLabel,
          style: Theme.of(context).primaryTextTheme.headlineSmall,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Navigator(
        key: key,
        initialRoute: initialRoute,
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == initialRoute) {
            return Routes.getRouteGenerate(RouteSettings(
              name: initialRoute,
              arguments: routeData,
            ));
          }
          return Routes.getRouteGenerate(settings);
        },
      ),
    );
  }
}
