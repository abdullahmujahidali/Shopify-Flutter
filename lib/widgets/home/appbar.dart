import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/app_model.dart';
import '../../models/cart/cart_base.dart';
import '../../models/notification_model.dart';
import '../../modules/dynamic_layout/config/logo_config.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../modules/dynamic_layout/logo/logo.dart';
import '../../routes/flux_navigate.dart';
import 'preview_overlay.dart';

class HomeAppBar extends StatefulWidget {
  final configs;
  final bool isPinAppBar;

  const HomeAppBar({
    Key? key,
    this.configs,
    this.isPinAppBar = false,
  }) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    if (Layout.isDisplayDesktop(context)) {
      return const SliverToBoxAdapter();
    }

    List<dynamic> horizonLayout = widget.configs['HorizonLayout'] ?? [];
    Map logoConfig = horizonLayout.firstWhere(
        (element) => element['layout'] == 'logo',
        orElse: () => Map<String, dynamic>.from({}));
    var config = LogoConfig.fromJson(logoConfig);

    /// customize theme
    // config
    //   ..opacity = 0.9
    //   ..iconBackground = HexColor('DDDDDD')
    //   ..iconColor = HexColor('330000')
    //   ..iconOpacity = 0.8
    //   ..iconRadius = 40
    //   ..iconSize = 24
    //   ..cartIcon = MenuIcon(name: 'cart')
    //   ..showSearch = false
    //   ..showLogo = true
    //   ..showCart = true
    //   ..showMenu = true;

    return SliverAppBar(
      pinned: widget.isPinAppBar,
      snap: true,
      floating: true,
      titleSpacing: 0,
      elevation: 0,
      forceElevated: true,
      backgroundColor: config.color ??
          Theme.of(context).colorScheme.background.withOpacity(config.opacity),
      title: PreviewOverlay(
          index: 0,
          config: logoConfig as Map<String, dynamic>?,
          builder: (value) {
            final appModel = Provider.of<AppModel>(context, listen: true);
            return Selector<CartModel, int>(
              selector: (_, cartModel) => cartModel.totalCartQuantity,
              builder: (context, totalCart, child) {
                return Logo(
                  config: config,
                  logo: appModel.themeConfig.logo,
                  notificationCount:
                      Provider.of<NotificationModel>(context).unreadCount,
                  totalCart: totalCart,
                  onSearch: () {
                    FluxNavigate.pushNamed(RouteList.homeSearch);
                  },
                  onCheckout: () {
                    FluxNavigate.pushNamed(RouteList.cart);
                  },
                  onTapNotifications: () {
                    FluxNavigate.pushNamed(RouteList.notify);
                  },
                  onTapDrawerMenu: () =>
                      NavigateTools.onTapOpenDrawerMenu(context),
                );
              },
            );
          }),
    );
  }
}
