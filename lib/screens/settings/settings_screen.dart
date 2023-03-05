import 'package:flutter/cupertino.dart'
    show
        CupertinoAlertDialog,
        CupertinoDialogAction,
        CupertinoIcons,
        showCupertinoDialog;
import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../common/config.dart';
import '../../common/config/configuration_utils.dart';
import '../../common/constants.dart';
import '../../common/events.dart';
import '../../common/tools.dart';
import '../../data/boxes.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show AppModel, ProductWishListModel, User, UserModel;
import '../../models/notification_model.dart';
import '../../modules/dynamic_layout/config/app_config.dart';
import '../../routes/flux_navigate.dart';
import '../../services/index.dart';
import '../../widgets/common/index.dart';
import '../../widgets/general/index.dart';
import '../common/app_bar_mixin.dart';
import '../common/delete_account_mixin.dart';
import '../index.dart';
import '../users/user_point_screen.dart';
import 'rate_myapp_mixin.dart';

const itemPadding = 15.0;

class SettingScreen extends StatefulWidget {
  final List<dynamic>? settings;
  final Map? subGeneralSetting;
  final String? background;
  final Map? drawerIcon;
  final bool hideUser;

  const SettingScreen({
    this.settings,
    this.subGeneralSetting,
    this.background,
    this.drawerIcon,
    this.hideUser = false,
  });

  @override
  SettingScreenState createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<SettingScreen>,
        DeleteAccountMixin,
        RateMyAppMixin,
        AppBarMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  User? get user => Provider.of<UserModel>(context, listen: false).user;
  bool isAbleToPostManagement = false;

  final bannerHigh = 150.0;

  void checkAddPostRole() {
    for (var legitRole in addPostAccessibleRoles) {
      if (user!.role == legitRole) {
        setState(() {
          isAbleToPostManagement = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    screenScrollController = _scrollController;
  }

  /// Render the Delivery Menu.
  /// Currently support WCFM
  Widget renderDeliveryBoy() {
    var isDelivery = user?.isDeliveryBoy ?? false;

    if (!isDelivery) {
      return const SizedBox();
    }

    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          FluxNavigate.push(
            MaterialPageRoute(
              builder: (context) =>
                  Services().widget.getDeliveryScreen(context, user)!,
            ),
            forceRootNavigator: true,
          );
        },
        leading: Icon(
          CupertinoIcons.cube_box,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).deliveryManagement,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  /// Render the Admin Vendor Menu.
  /// Currently support WCFM & Dokan. Will support WooCommerce soon.
  Widget renderVendorAdmin() {
    var isVendor = user?.isVender ?? false;

    if (!isVendor ||
        ServerConfig().isListeoType ||
        !ServerConfig().typeName.isMultiVendor) {
      return const SizedBox();
    }

    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          FluxNavigate.pushNamed(
            RouteList.vendorAdmin,
            arguments: user,
            forceRootNavigator: true,
          );
        },
        leading: Icon(
          Icons.dashboard,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).vendorAdmin,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget renderVendorVacation() {
    var isVendor = user?.isVender ?? false;

    if ((ServerConfig().typeName.isMultiVendor && !isVendor) ||
        !ServerConfig().typeName.isWcfm ||
        !kVendorConfig.disableNativeStoreManagement) {
      return const SizedBox();
    }

    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          FluxNavigate.push(
            MaterialPageRoute(
              builder: (context) => Services().widget.renderVacationVendor(
                    user!.id!,
                    user!.cookie!,
                    isFromMV: true,
                  ),
            ),
          );
        },
        leading: Icon(
          Icons.house,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).storeVacation,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  /// Render the custom profile link via Webview
  /// Example show some special profile on the woocommerce site: wallet, wishlist...
  Widget renderWebViewProfile() {
    if (user == null) {
      return const SizedBox();
    }

    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.only(bottom: 2.0),
      elevation: 0,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebView(
                auth: true,
                url: '${ServerConfig().url}/my-account',
                title: S.of(context).updateUserInfor,
              ),
            ),
          );
        },
        leading: Icon(
          CupertinoIcons.profile_circled,
          size: 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          S.of(context).updateUserInfor,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.secondary,
          size: 18,
        ),
      ),
    );
  }

  Widget renderItem(value) {
    IconData icon;
    String title;
    Widget? trailing;
    Function() onTap;
    var isMultiVendor = ServerConfig().typeName.isMultiVendor;
    var subGeneralSetting = widget.subGeneralSetting != null
        ? ConfigurationUtils.loadSubGeneralSetting(widget.subGeneralSetting!)
        : kSubGeneralSetting;
    var item = subGeneralSetting[value];

    if (value.contains('web')) {
      return GeneralWebWidget(item: item);
    }

    if (value.contains('post-')) {
      return GeneralPostWidget(item: item);
    }

    if (value.contains('title')) {
      return GeneralTitleWidget(item: item, itemPadding: itemPadding);
    }

    if (value.contains('button')) {
      return GeneralButtonWidget(item: item);
    }

    if (value.contains('product-')) {
      return GeneralProductWidget(item: item);
    }

    if (value.contains('category-')) {
      return GeneralCategoryWidget(item: item);
    }

    if (value.contains('banner-')) {
      return GeneralBannerWidget(item: item);
    }

    if (value.contains('blog-')) {
      return GeneralBlogWidget(item: item);
    }

    if (value.contains('blogCategory-')) {
      return GeneralBlogCategoryWidget(item: item);
    }

    switch (value) {
      case 'products':
        {
          if (!(user != null ? user!.isVender : false) || !isMultiVendor) {
            return const SizedBox();
          }
          title = S.of(context).myProducts;
          icon = CupertinoIcons.cube_box;
          onTap = () => Navigator.pushNamed(context, RouteList.productSell);
          break;
        }

      case 'chat':
        {
          if (user == null || ServerConfig().isListingType || !isMultiVendor) {
            return const SizedBox();
          }
          title = S.of(context).conversations;
          icon = CupertinoIcons.chat_bubble_2;
          onTap = () {
            Navigator.pushNamed(
              context,
              RouteList.listChat,
              arguments: isMultiVendor && user?.isVender == true,
            );
          };
          break;
        }
      case 'wallet':
        {
          if (user == null || !ServerConfig().isWooType) {
            return const SizedBox();
          }
          title = S.of(context).myWallet;
          icon = CupertinoIcons.square_favorites_alt;
          onTap = () => FluxNavigate.pushNamed(
                RouteList.myWallet,
                forceRootNavigator: true,
              );
          break;
        }
      case 'wishlist':
        {
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<ProductWishListModel>(
                builder: (context, model, child) {
                  if (model.products.isNotEmpty) {
                    return Text(
                      '${model.products.length} ${S.of(context).items}',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600)
            ],
          );

          title = S.of(context).myWishList;
          icon = CupertinoIcons.heart;
          onTap = () => Navigator.of(context).pushNamed(RouteList.wishlist);
          break;
        }
      case 'notifications':
        {
          return Consumer<NotificationModel>(builder: (context, model, child) {
            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.only(bottom: 2.0),
                  elevation: 0,
                  child: SwitchListTile(
                    secondary: Icon(
                      CupertinoIcons.bell,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 24,
                    ),
                    value: model.enable,
                    activeColor: const Color(0xFF0066B4),
                    onChanged: (bool enableNotification) {
                      if (enableNotification) {
                        model.enableNotification();
                      } else {
                        model.disableNotification();
                      }
                    },
                    title: Text(
                      S.of(context).getNotification,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black12,
                  height: 1.0,
                  indent: 75,
                  //endIndent: 20,
                ),
                if (model.enable) ...[
                  Card(
                    margin: const EdgeInsets.only(bottom: 2.0),
                    elevation: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteList.notify);
                      },
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.list_bullet,
                          size: 22,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(S.of(context).listMessages),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: kGrey600,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 1.0,
                    indent: 75,
                    //endIndent: 20,
                  ),
                ],
              ],
            );
          });
        }
      case 'language':
        {
          return Selector<AppModel, String?>(
            selector: (context, model) => model.langCode,
            builder: (context, langCode, _) {
              final languages = getLanguages();
              return _SettingItem(
                icon: CupertinoIcons.globe,
                title: S.of(context).language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      languages.firstWhere(
                        (element) => langCode == element['code'],
                        orElse: () => {'text': ''},
                      )['text'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kGrey600,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteList.language);
                },
              );
            },
          );
        }
      case 'currencies':
        {
          if (ServerConfig().isListingType) {
            return const SizedBox();
          }
          return Selector<AppModel, String?>(
            selector: (context, model) => model.currency,
            builder: (context, currency, _) {
              return _SettingItem(
                icon: CupertinoIcons.money_dollar_circle,
                title: S.of(context).currencies,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$currency',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kGrey600,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteList.currencies);
                },
              );
            },
          );
        }
      case 'darkTheme':
        {
          return Selector<AppModel, bool>(
            selector: (context, model) => model.darkTheme,
            builder: (context, darkTheme, _) {
              return _SettingItem(
                icon: darkTheme ? CupertinoIcons.moon : CupertinoIcons.sun_min,
                title: S.of(context).appearance,
                trailing: Text(
                  darkTheme
                      ? S.of(context).darkTheme
                      : S.of(context).lightTheme,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  context.read<AppModel>().updateTheme(!darkTheme);
                },
              );
            },
          );
        }
      case 'order':
        {
          var items = UserBox().orders;
          if (user == null && items.isEmpty) {
            return const SizedBox();
          }
          if (ServerConfig().isListingType) {
            return const SizedBox();
          }
          icon = CupertinoIcons.time;
          title = S.of(context).orderHistory;
          onTap = () {
            final user = Provider.of<UserModel>(context, listen: false).user;
            FluxNavigate.pushNamed(
              RouteList.orders,
              arguments: user,
            );
          };
          break;
        }
      case 'point':
        {
          if (!(kAdvanceConfig.enablePointReward && user != null)) {
            return const SizedBox();
          }
          if (ServerConfig().isListingType) {
            return const SizedBox();
          }
          icon = CupertinoIcons.bag_badge_plus;
          title = S.of(context).myPoints;
          onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPointScreen(),
                ),
              );
          break;
        }
      case 'rating':
        {
          icon = CupertinoIcons.star;
          title = S.of(context).rateTheApp;
          onTap = showRateMyApp;
          break;
        }
      case 'privacy':
        {
          icon = CupertinoIcons.doc_text;
          title = S.of(context).agreeWithPrivacy;
          onTap = () {
            final privacy = subGeneralSetting['privacy'];
            final pageId = privacy?.pageId ??
                (privacy?.webUrl == null
                    ? kAdvanceConfig.privacyPoliciesPageId
                    : null);
            String? pageUrl =
                privacy?.webUrl ?? kAdvanceConfig.privacyPoliciesPageUrl;
            if (pageId != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(
                      pageId: pageId,
                      pageTitle: S.of(context).agreeWithPrivacy,
                    ),
                  ));
              return;
            }
            if (pageUrl.isNotEmpty) {
              ///Display multiple languages WebView
              var locale =
                  Provider.of<AppModel>(context, listen: false).langCode;
              pageUrl += '?lang=$locale';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: pageUrl,
                    title: S.of(context).agreeWithPrivacy,
                  ),
                ),
              );
            }
          };
          break;
        }
      case 'about':
        {
          icon = CupertinoIcons.info;
          title = S.of(context).aboutUs;
          onTap = () {
            final about = subGeneralSetting['about'];
            final aboutUrl = about?.webUrl ?? SettingConstants.aboutUsUrl;

            if (kIsWeb) {
              return Tools.launchURL(aboutUrl);
            }
            return FluxNavigate.push(
              MaterialPageRoute(
                builder: (context) => WebView(
                  url: aboutUrl,
                  // title: S.of(context).aboutUs,
                ),
              ),
            );
          };
          break;
        }

      case 'post':
        {
          if (user != null) {
            trailing = const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: kGrey600,
            );
            title = S.of(context).postManagement;
            icon = CupertinoIcons.chat_bubble_2;
            onTap = () {
              Navigator.of(context).pushNamed(RouteList.postManagement);
            };
          } else {
            return const SizedBox();
          }

          break;
        }
      default:
        {
          trailing =
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
          icon = Icons.error;
          title = S.of(context).dataEmpty;
          onTap = () {};
        }
    }
    return _SettingItem(
      icon: icon,
      title: title,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _handleUpdateProfile() async {
    final hasChangePassword = await FluxNavigate.pushNamed(
      RouteList.updateUser,
    ) as bool?;

    /// If change password with Shopify
    /// need to log out and log in again
    if (ServerConfig().isShopify && (hasChangePassword ?? false)) {
      await _showDialogLogout();
    }
  }

  Widget renderDrawerIcon() {
    var icon = Icons.blur_on;
    if (widget.drawerIcon != null) {
      icon = iconPicker(
              widget.drawerIcon!['icon'], widget.drawerIcon!['fontFamily']) ??
          Icons.blur_on;
    }
    return Icon(
      icon,
      color: Colors.white70,
    );
  }

  Widget renderUser() {
    return ListenableProvider.value(
      value: Provider.of<UserModel>(context),
      child: Consumer<UserModel>(
        builder: (context, model, child) {
          final user = model.user;
          final loggedIn = model.loggedIn;
          return Column(children: [
            const SizedBox(height: 10.0),
            if (user != null && user.name != null)
              ListTile(
                leading: (user.picture?.isNotEmpty ?? false)
                    ? Hero(
                        tag: 'user-avatar-${user.picture}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FluxImage(
                            imageUrl: user.picture!,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      )
                    : const Icon(Icons.face),
                title: Text(
                  user.name ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                horizontalTitleGap: 24.0,
                subtitle: (user.identifierInformation.isNotEmpty)
                    ? Text(
                        user.identifierInformation,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : null,
                onTap: _handleUpdateProfile,
                trailing: !ServerConfig().isWordPress
                    ? IconButton(
                        onPressed: _handleUpdateProfile,
                        icon: const Icon(Icons.edit),
                      )
                    : null,
              ),
            if (user == null)
              Card(
                color: Theme.of(context).colorScheme.background,
                margin: const EdgeInsets.only(bottom: 2.0),
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    if (!loggedIn) {
                      NavigateTools.navigateToLogin(context);
                      return;
                    }
                    Provider.of<UserModel>(context, listen: false).logout();
                    if (kLoginSetting.isRequiredLogin) {
                      Navigator.of(
                        App.fluxStoreNavigatorKey.currentContext!,
                      ).pushNamedAndRemoveUntil(
                        RouteList.login,
                        (route) => false,
                      );
                    }
                  },
                  leading: const Icon(Icons.person),
                  title: Text(
                    loggedIn ? S.of(context).logout : S.of(context).login,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 18, color: kGrey600),
                ),
              ),
            if (user != null)
              Card(
                color: Theme.of(context).colorScheme.background,
                margin: const EdgeInsets.only(bottom: 2.0),
                elevation: 0,
                child: ListTile(
                  onTap: _onLogout,
                  leading: Icon(
                    Icons.logout,
                    size: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),

                  // Image.asset(
                  //   'assets/icons/profile/icon-logout.png',
                  //   width: 24,
                  //   color: Theme.of(context).colorScheme.secondary,
                  // ),
                  title: Text(
                    S.of(context).logout,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 18, color: kGrey600),
                ),
              ),
          ]);
        },
      ),
    );
  }

  List<Widget>? renderActions({Color? color, bool sliver = false}) {
    var canPop = ModalRoute.of(context)?.canPop ?? false;
    var popButton = GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(
        Icons.close,
        color: color ?? Colors.white,
      ),
    );
    var actions = sliver
        ? <Widget>[
            Selector<AppModel, AppBarConfig?>(
              selector: (context, model) => model.appConfig?.appBar,
              shouldRebuild: (oldValue, newValue) =>
                  oldValue?.toJson().toString() !=
                  newValue?.toJson().toString(),
              builder: (context, value, child) {
                return ValueListenableBuilder<bool>(
                  valueListenable: isAtTopNotifier,
                  builder: (context, bool isAtTop, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.symmetric(vertical: isAtTop ? 4 : 0),
                      decoration: value?.backgroundColor != null
                          ? BoxDecoration(
                              color: HexColor(value?.backgroundColor),
                            )
                          : null,
                      child: popButton,
                    );
                  },
                );
              },
            )
          ]
        : <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: popButton,
            )
          ];
    return canPop ? actions : null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var settings = widget.settings ?? kDefaultSettings;
    var background = widget.background ?? kProfileBackground;

    final appBarWidget = (showAppBar(RouteList.profile))
        ? getSliverAppBarWidget(
            appBar: appBar,
            actions: renderActions(
              color: Theme.of(context).colorScheme.secondary,
              sliver: true,
            ),
          )
        : SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: (context.read<AppModel>().appConfig?.drawer?.enable ??
                    true)
                ? IconButton(
                    icon: renderDrawerIcon(),
                    onPressed: () => NavigateTools.onTapOpenDrawerMenu(context),
                  )
                : null,
            expandedHeight: bannerHigh,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                S.of(context).settings,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              background: FluxImage(
                imageUrl: background,
                fit: BoxFit.cover,
              ),
            ),
            actions: renderActions(),
          );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          appBarWidget,
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (!widget.hideUser) renderUser(),
                      const SizedBox(height: 30.0),
                      Text(
                        S.of(context).generalSetting,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10.0),
                      renderVendorAdmin(),

                      /// Render some extra menu for Vendor.
                      /// Currently support WCFM & Dokan. Will support WooCommerce soon.
                      if (ServerConfig().typeName.isMultiVendor &&
                          (user?.isVender ?? false)) ...[
                        Services().widget.renderVendorOrder(context),
                        renderVendorVacation(),
                      ],

                      renderDeliveryBoy(),

                      /// Render custom Wallet feature
                      // renderWebViewProfile(),

                      /// render some extra menu for Listing
                      if (user != null && ServerConfig().isListingType) ...[
                        Services().widget.renderNewListing(context),
                        Services().widget.renderBookingHistory(context),
                      ],

                      const SizedBox(height: 10.0),
                      if (user != null)
                        const Divider(
                          color: Colors.black12,
                          height: 1.0,
                          indent: 75,
                          //endIndent: 20,
                        ),
                    ],
                  ),
                ),

                /// render list of dynamic menu
                /// this could be manage from the Fluxbuilder
                ...List.generate(
                  settings.length,
                  (index) {
                    var item = settings[index];
                    var isTitle = item.contains('title');
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTitle ? 0.0 : itemPadding,
                      ),
                      child: renderItem(item),
                    );
                  },
                ),
                if (user != null &&
                    kAdvanceConfig.gdprConfig.showDeleteAccount &&
                    ServerConfig().isSupportDeleteAccount)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: itemPadding),
                    child: _SettingItem(
                      iconWidget: const Icon(
                        CupertinoIcons.delete,
                        color: kColorRed,
                        size: 22,
                      ),
                      titleWidget: Text(
                        S.current.deleteAccount,
                        style: const TextStyle(color: kColorRed),
                      ),
                      onTap: () async {
                        final acceptDelete =
                            await showConfirmDeleteAccountDialog(
                          App.fluxStoreNavigatorKey.currentContext ?? context,
                        );
                        if (acceptDelete) {
                          _processDeleteAccount();
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 180),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _processDeleteAccount() async {
    final result = await FluxNavigate.pushNamed(
      RouteList.deleteAccount,
      arguments: DeleteAccountArguments(
        confirmCaptcha: kAdvanceConfig.gdprConfig.confirmCaptcha,
        userToken:
            Provider.of<UserModel>(context, listen: false).user?.cookie ?? '',
      ),
    ) as bool?;
    if (result ?? false) {
      _deleteUserOnFirebase();
      _onLogout();
    }
  }

  void _onLogout() {
    eventBus.fire(const EventExpiredCookie());
  }

  void _deleteUserOnFirebase() {
    Services().firebase.deleteAccount();
  }

  /// Need to force log out when change the password for Shopify
  Future<void> _showDialogLogout() async {
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(S.current.notice),
        content: Text(S.current.needToLoginAgain),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              _onLogout();
            },
            child: Text(S.current.ok),
          )
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String? title;
  final Widget? titleWidget;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    Key? key,
    this.icon,
    this.iconWidget,
    this.title,
    this.titleWidget,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 2.0),
          elevation: 0,
          child: ListTile(
            leading: icon != null
                ? Icon(
                    icon,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 24,
                  )
                : iconWidget,
            title: title != null
                ? Text(
                    title!,
                    style: const TextStyle(fontSize: 16),
                  )
                : titleWidget,
            trailing: trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: kGrey600,
                ),
            onTap: onTap,
          ),
        ),
        const Divider(
          color: Colors.black12,
          height: 1.0,
          indent: 75,
          //endIndent: 20,
        ),
      ],
    );
  }
}
