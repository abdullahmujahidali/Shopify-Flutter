import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/config/models/index.dart';
import '../common/constants.dart';
import '../generated/l10n.dart';
import '../models/index.dart'
    show AppModel, BackDropArguments, Category, CategoryModel, UserModel;
import '../modules/dynamic_layout/config/app_config.dart';
import '../modules/dynamic_layout/helper/helper.dart';
import '../routes/flux_navigate.dart';
import '../services/index.dart';
import '../widgets/common/index.dart' show FluxImage, WebView;
import '../widgets/general/index.dart';
import 'maintab_delegate.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu();

  @override
  MenuBarState createState() => MenuBarState();
}

class MenuBarState extends State<SideBarMenu> {
  bool get isEcommercePlatform =>
      !ServerConfig().isListingType || !ServerConfig().isWordPress;

  DrawerMenuConfig get drawer =>
      Provider.of<AppModel>(context, listen: false).appConfig?.drawer ??
      kDefaultDrawer;

  void pushNavigation(String name) {
    eventBus.fire(const EventCloseNativeDrawer());
    MainTabControlDelegate.getInstance().changeTab(name.replaceFirst('/', ''));
  }

  @override
  Widget build(BuildContext context) {
    printLog('[AppState] Load Menu');

    return SafeArea(
      top: drawer.safeArea,
      right: false,
      bottom: false,
      left: false,
      child: Padding(
        key: drawer.key != null ? Key(drawer.key as String) : UniqueKey(),
        padding: EdgeInsets.only(
            bottom:
                injector<AudioManager>().isStickyAudioWidgetActive ? 46 : 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (drawer.logo != null) ...[
                Container(
                  color: drawer.logoConfig.backgroundColor != null
                      ? HexColor(drawer.logoConfig.backgroundColor)
                      : null,
                  padding: EdgeInsets.only(
                    bottom: drawer.logoConfig.marginBottom.toDouble(),
                    top: drawer.logoConfig.marginTop.toDouble(),
                    left: drawer.logoConfig.marginLeft.toDouble(),
                    right: drawer.logoConfig.marginRight.toDouble(),
                  ),
                  child: FluxImage(
                    width: drawer.logoConfig.useMaxWidth
                        ? MediaQuery.of(context).size.width
                        : drawer.logoConfig.width?.toDouble(),
                    fit: Helper.boxFit(drawer.logoConfig.boxFit),
                    height: drawer.logoConfig.height.toDouble(),
                    imageUrl: drawer.logo as String,
                  ),
                ),
                const Divider(),
              ],
              ...List.generate(
                drawer.items?.length ?? 0,
                (index) {
                  return drawerItem(
                    drawer.items![index],
                    drawer.subDrawerItem ?? {},
                    textColor: drawer.textColor != null
                        ? HexColor(drawer.textColor)
                        : null,
                    iconColor: drawer.iconColor != null
                        ? HexColor(drawer.iconColor)
                        : null,
                  );
                },
              ),
              Layout.isDisplayDesktop(context)
                  ? const SizedBox(height: 300)
                  : const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(
    DrawerItemsConfig drawerItemConfig,
    Map<String, GeneralSettingItem> subDrawerItem, {
    Color? iconColor,
    Color? textColor,
  }) {
    // final isTablet = Tools.isTablet(MediaQuery.of(context));

    if (drawerItemConfig.show == false) return const SizedBox();
    var value = drawerItemConfig.type;
    var textStyle = TextStyle(
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );

    switch (value) {
      case 'home':
        {
          return ListTile(
            leading: Icon(
              isEcommercePlatform ? Icons.home : Icons.shopping_basket,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              isEcommercePlatform ? S.of(context).home : S.of(context).shop,
              style: textStyle,
            ),
            onTap: () {
              pushNavigation(RouteList.home);
            },
          );
        }
      case 'categories':
        {
          return ListTile(
            leading: Icon(
              Icons.category,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).categories,
              style: textStyle,
            ),
            onTap: () => pushNavigation(
              !Provider.of<AppModel>(context, listen: false).isMultivendor
                  ? RouteList.category
                  : RouteList.vendorCategory,
            ),
          );
        }
      case 'cart':
        {
          if ((!Services().widget.enableShoppingCart(null)) ||
              ServerConfig().isListingType) {
            return const SizedBox();
          }
          return ListTile(
            leading: Icon(
              Icons.shopping_cart,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).cart,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.cart),
          );
        }
      case 'profile':
        {
          return ListTile(
            leading: Icon(
              Icons.person,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).settings,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.profile),
          );
        }
      case 'web':
        {
          return ListTile(
            leading: Icon(
              Icons.web,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).webView,
              style: textStyle,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: 'https://inspireui.com',
                    title: S.of(context).webView,
                  ),
                ),
              );
            },
          );
        }
      case 'blog':
        {
          return ListTile(
            leading: Icon(
              CupertinoIcons.news_solid,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).blog,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.listBlog),
          );
        }
      case 'login':
        {
          return ListenableProvider.value(
            value: Provider.of<UserModel>(context, listen: false),
            child: Consumer<UserModel>(builder: (context, userModel, _) {
              final loggedIn = userModel.loggedIn;
              return ListTile(
                leading: Icon(Icons.exit_to_app, size: 20, color: iconColor),
                title: loggedIn
                    ? Text(S.of(context).logout, style: textStyle)
                    : Text(S.of(context).login, style: textStyle),
                onTap: () {
                  if (loggedIn) {
                    Provider.of<UserModel>(context, listen: false).logout();
                    if (Services().widget.isRequiredLogin) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteList.login,
                        (route) => false,
                      );
                    }
                    // else {
                    //   pushNavigation(RouteList.dashboard);
                    // }
                  } else {
                    pushNavigation(RouteList.login);
                  }
                },
              );
            }),
          );
        }
      case 'category':
        {
          return buildListCategory(textStyle: textStyle);
        }
      default:
        {
          var item = subDrawerItem[value];
          if (value?.contains('web') ?? false) {
            return GeneralWebWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
          if (value?.contains('post') ?? false) {
            return GeneralPostWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
          if (value?.contains('title') ?? false) {
            return GeneralTitleWidget(item: item);
          }
          if (value?.contains('button') ?? false) {
            return GeneralButtonWidget(item: item);
          }
          if (value?.contains('product') ?? false) {
            return GeneralProductWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
          if (value?.contains('category') ?? false) {
            return GeneralCategoryWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
          if (value?.contains('banner') ?? false) {
            return GeneralBannerWidget(
              item: item,
            );
          }
          if (value?.contains('blogCategory') ?? false) {
            return GeneralBlogCategoryWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
          if (value?.contains('blog') ?? false) {
            return GeneralBlogWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
        }

        return const SizedBox();
    }
  }

  Widget buildListCategory({TextStyle? textStyle}) {
    return Selector<CategoryModel, List<Category>?>(
      shouldRebuild: (previous, next) {
        return previous != next;
      },
      selector: (context, provider) => provider.categories,
      builder: (context, categories, child) {
        var widgets = <Widget>[];

        if (categories != null) {
          var list = categories.where((item) => item.isRoot).toList();
          for (var i = 0; i < list.length; i++) {
            final currentCategory = list[i];
            var childCategories = categories
                .where((o) => o.parent == currentCategory.id)
                .toList();
            widgets.add(Container(
              color: i.isOdd
                  ? null
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.1),

              /// Check to add only parent link category
              child: childCategories.isEmpty
                  ? InkWell(
                      onTap: () => navigateToBackDrop(currentCategory),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                          bottom: 12,
                          left: 16,
                          top: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              currentCategory.name!.toUpperCase(),
                              style: textStyle,
                            )),
                            const SizedBox(width: 24),
                            currentCategory.totalProduct == null
                                ? const Icon(Icons.chevron_right)
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      S.of(context).nItems(
                                          currentCategory.totalProduct!),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  : ExpansionTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 0),
                        child: Text(
                          currentCategory.name!.toUpperCase(),
                          style: textStyle?.copyWith(fontSize: 14) ??
                              const TextStyle(fontSize: 14),
                        ),
                      ),
                      textColor: Theme.of(context).primaryColor,
                      iconColor: Theme.of(context).primaryColor,
                      children: getChildren(
                              categories, currentCategory, childCategories)
                          as List<Widget>,
                    ),
            ));
          }
        }

        return ExpansionTile(
          initiallyExpanded: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          tilePadding: const EdgeInsets.only(left: 16, right: 8),
          title: Text(
            S.of(context).byCategory.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textStyle?.color ??
                  Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
          ),
          children: widgets,
        );
      },
    );
  }

  List getChildren(
    List<Category> categories,
    Category currentCategory,
    List<Category> childCategories, {
    double paddingOffset = 0.0,
  }) {
    var list = <Widget>[];
    final totalProduct = currentCategory.totalProduct;
    list.add(
      ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 20 + paddingOffset),
          child: Text(S.of(context).seeAll),
        ),
        trailing: ((totalProduct != null && totalProduct > 0))
            ? Text(
                S.of(context).nItems(totalProduct),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              )
            : null,
        onTap: () => navigateToBackDrop(currentCategory),
      ),
    );
    for (var i in childCategories) {
      var newChildren = categories.where((cat) => cat.parent == i.id).toList();
      if (newChildren.isNotEmpty) {
        list.add(
          ExpansionTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20.0 + paddingOffset),
              child: Text(
                i.name!.toUpperCase(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            children: getChildren(
              categories,
              i,
              newChildren,
              paddingOffset: paddingOffset + 10,
            ) as List<Widget>,
          ),
        );
      } else {
        final totalProduct = i.totalProduct;
        list.add(
          ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20 + paddingOffset),
              child: Text(i.name!),
            ),
            trailing: (totalProduct != null && totalProduct > 0)
                ? Text(
                    S.of(context).nItems(i.totalProduct!),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  )
                : null,
            onTap: () => navigateToBackDrop(i),
          ),
        );
      }
    }
    return list;
  }

  void navigateToBackDrop(Category category) {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: category.id,
        cateName: category.name,
      ),
    );
  }
}
