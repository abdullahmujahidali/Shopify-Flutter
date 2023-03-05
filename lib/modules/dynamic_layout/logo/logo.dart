import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart' deferred as defer_icon;
import 'package:inspireui/inspireui.dart' show DeferredWidget;

import '../../../widgets/common/flux_image.dart';
import '../config/logo_config.dart';

const double kSizeLogo = 50;

class LogoIcon extends StatelessWidget {
  final LogoConfig config;
  final Function onTap;
  final MenuIcon? menuIcon;

  const LogoIcon({
    Key? key,
    required this.config,
    required this.onTap,
    this.menuIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      key: const Key('drawerMenu'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          config.iconRadius,
        ),
      ),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      fillColor: config.iconBackground != null
          ? config.iconBackground!.withOpacity(config.iconOpacity)
          : Theme.of(context).colorScheme.background.withOpacity(config.iconOpacity),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      onPressed: () => onTap.call(),
      child: menuIcon != null
          ? DeferredWidget(
              defer_icon.loadLibrary,
              () => Icon(
                defer_icon.iconPicker(
                  menuIcon!.name!,
                  menuIcon!.fontFamily ?? 'CupertinoIcons',
                ),
                color: config.iconColor ??
                    Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                size: config.iconSize,
              ),
            )
          : Icon(
              Icons.blur_on,
              color: config.iconColor ??
                  Theme.of(context).colorScheme.secondary.withOpacity(0.9),
              size: config.iconSize,
            ),
    );
  }
}

class Logo extends StatelessWidget {
  final onSearch;
  final onCheckout;
  final onTapDrawerMenu;
  final onTapNotifications;
  final String? logo;
  final LogoConfig config;
  final int totalCart;
  final int notificationCount;

  const Logo({
    Key? key,
    required this.config,
    required this.onSearch,
    required this.onCheckout,
    required this.onTapDrawerMenu,
    required this.onTapNotifications,
    this.logo,
    this.totalCart = 0,
    this.notificationCount = 0,
  }) : super(key: key);

  Widget renderLogo() {
    if (config.image != null) {
      if (config.image!.contains('http')) {
        return SizedBox(
          height: kSizeLogo - 10,
          child: FluxImage(
            imageUrl: config.image!,
            height: kSizeLogo,
            fit: BoxFit.contain,
          ),
        );
      }
      return Image.asset(
        config.image!,
        height: kSizeLogo,
      );
    }

    /// render from config to support dark/light theme
    if (logo != null) {
      return FluxImage(imageUrl: logo!, height: kSizeLogo);
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          constraints: const BoxConstraints(minHeight: 40.0),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Expanded(
                child: (config.showMenu ?? false)
                    ? LogoIcon(
                        menuIcon: config.menuIcon,
                        onTap: onTapDrawerMenu,
                        config: config,
                      )
                    : const SizedBox(),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (config.showLogo) Center(child: renderLogo()),
                        if (config.name?.isNotEmpty ?? false) ...[
                          const SizedBox(width: 5),
                          Text(
                            config.name!,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (config.showSearch)
                Expanded(
                  child: LogoIcon(
                    menuIcon: config.searchIcon ?? MenuIcon(name: 'search'),
                    onTap: onSearch,
                    config: config,
                  ),
                ),
              if (config.showCart)
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      LogoIcon(
                        menuIcon: config.cartIcon ?? MenuIcon(name: 'bag'),
                        onTap: onCheckout,
                        config: config,
                      ),
                      if (totalCart > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              totalCart.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              if (config.showNotification)
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      LogoIcon(
                        menuIcon:
                            config.notificationIcon ?? MenuIcon(name: 'bell'),
                        onTap: onTapNotifications,
                        config: config,
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              notificationCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              if (!config.showSearch &&
                  !config.showCart &&
                  !config.showNotification)
                const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
