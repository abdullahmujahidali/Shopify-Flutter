import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show AutoHideKeyboard;
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../menu/maintab.dart';
import '../models/brand_model.dart';
import '../models/index.dart'
    show
        AppModel,
        BackDropArguments,
        BlogModel,
        Product,
        ProductModel,
        User,
        UserModel;
import '../modules/dynamic_layout/geo_search/geo_search_screen.dart';
import '../modules/dynamic_layout/helper/helper.dart';
import '../modules/dynamic_layout/index.dart';
import '../modules/product_reviews/models/product_reviews_model.dart';
import '../modules/product_reviews/product_review_screen.dart';
import '../modules/sms_login/sms_login.dart';
import '../screens/brand/brand_backdrop.dart';
import '../screens/dynamic/dynamic_scrollable_screen.dart';
import '../screens/dynamic/dynamic_tabmenu_screen.dart';
import '../screens/index.dart';
import '../screens/login_sms/login_sms_viewmodel.dart';
import '../screens/order_history/index.dart';
import '../screens/page_tab_screen.dart';
import '../screens/pages/static_page.dart';
import '../screens/subcategories/models/subcategory_model.dart';
import '../screens/user_update/user_update_screen.dart';
import '../screens/user_update/user_update_woo_screen.dart';
import '../services/index.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll() => _routes;

  static final Map<String, WidgetBuilder> _routes = {
    RouteList.dashboard: (context) => const MainTabs(),
    RouteList.notificationRequest: (context) =>
        const NotificationRequestScreen(),
    RouteList.privacyTerms: (context) => const PrivacyTermScreen(),
    RouteList.register: (context) => const RegistrationScreen(),
    RouteList.login: (context) {
      final userModel = Provider.of<UserModel>(context, listen: false);
      return LoginScreen(
        login: userModel.login,
        loginFB: userModel.loginFB,
        loginApple: userModel.loginApple,
        loginGoogle: userModel.loginGoogle,
      );
    },
    RouteList.loginSMS: (context) {
      final userModel = Provider.of<UserModel>(context, listen: false);
      if (kAdvanceConfig.enableNewSMSLogin) {
        return SMSLoginScreen(
          onSuccess: (user) async {
            await userModel.setUser(user);
            NavigateTools.navigateAfterLogin(user, context);
          },
        );
      }
      return ChangeNotifierProvider<LoginSmsViewModel>(
        create: (context) => LoginSmsViewModel(Services().firebase),
        child: const LoginSMSScreen(),
      );
    },
    RouteList.products: (context) => const ProductsScreen(),
    RouteList.wishlist: (context) => Services().widget.renderWishListScreen(),
    RouteList.notify: (context) => NotificationScreen(),
    RouteList.language: (context) => LanguageScreen(),
    RouteList.currencies: (context) => CurrenciesScreen(),
    RouteList.category: (context) => const CategoriesScreen(),
    RouteList.audioPlaylist: (context) =>
        Services().renderAudioPlaylistScreen(),
    // AudioPlaylistScreen(audioService: injector.get()),
  };

  static Route getRouteGenerate(RouteSettings settings) {
    var routingData = settings.name!.getRoutingData;

    printLog('[🧬Builder RouteGenerate] ${routingData.route}');

    switch (routingData.route) {
      case RouteList.backdrop:
        final arguments = settings.arguments;
        if (arguments is BackDropArguments) {
          final config = arguments.config;

          var isWordpressBlog;

          // Brand Back Drop
          if (arguments.brandId != null) {
            var routeSetting = RouteSettings(
                name: RouteList.brand, arguments: settings.arguments);

            return _buildRoute(routeSetting, (context) {
              final brandId = arguments.brandId;
              final brandName = arguments.brandName;
              final brandImg = arguments.brandImg;
              final config = arguments.config;
              final brandModel =
                  Provider.of<BrandModel>(context, listen: false);

              if (brandId != null) {
                brandModel.fetchProductsByBrand(
                  brandId: brandId,
                  brandName: brandName,
                  brandImg: brandImg,
                );
              }

              brandModel.setProductList(<Product>[]); //clear old products
              brandModel.getProductList(
                brandId: brandId,
                page: 1,
                lang: Provider.of<AppModel>(context, listen: false).langCode,
              );
              return BrandPage(
                brandId: brandId,
                config: config,
              );
            });
          }

          if (config != null && !ServerConfig().isWordPress) {
            /// Navigate from "See All" in dynamic_blog
            isWordpressBlog = config['type'] == 'blog';
          } else {
            isWordpressBlog = ServerConfig().isWordPress;
          }

          /// is Wordpress Blog list
          /// That mean support backdrop, category, etc
          if (isWordpressBlog) {
            final routeSetting = RouteSettings(
                name: RouteList.blogs, arguments: settings.arguments);

            return _buildRoute(routeSetting, (context) {
              final cateId = arguments.cateId;
              final cateName = arguments.cateName;
              final blogs = arguments.data?.cast<Blog>();
              final config = arguments.config;
              var categoryId = cateId ?? config?['category'];

              var categoryName = cateName ?? config?['name'];
              final blogModel = Provider.of<BlogModel>(context, listen: false);

              if (categoryId != null) {
                blogModel.fetchBlogsByCategory(
                  categoryId: categoryId,
                  categoryName: categoryName,
                );
              } else {
                blogModel.categoryName = categoryName;
              }

              // for caching current blogs list
              if (blogs != null && blogs.isNotEmpty) {
                blogModel.setBlogNewsList(blogs);
                return BlogsPage(blogs: blogs, categoryId: categoryId);
              }

              blogModel.setBlogsList(<Blog>[]); //clear old products
              blogModel.getBlogsList(
                categoryId: categoryId,
                categoryName: categoryName,
                page: 1,
                lang: Provider.of<AppModel>(context, listen: false).langCode,
              );
              return BlogsPage(blogs: blogs ?? [], categoryId: categoryId);
            });
          }

          // Woo
          final routeSetting = RouteSettings(
              name: RouteList.products, arguments: settings.arguments);

          return _buildRoute(routeSetting, (context) {
            final cateId = arguments.cateId;
            final cateName = arguments.cateName;
            final tag = arguments.tag;
            final products = arguments.data?.cast<Product>();
            final config = arguments.config;
            final showCountdown = arguments.showCountdown;
            final countdownDuration = arguments.countdownDuration;
            try {
              var configValue = config != null
                  ? ProductConfig.fromJson(config)
                  : ProductConfig.empty();

              var categoryId = cateId ?? configValue.category;
              var categoryName = cateName ?? configValue.name;
              var listingLocationId = config?['location']?.toString();

              var tagId = tag ?? configValue.tag;

              if (kIsWeb ||
                  (Layout.isDisplayDesktop(context) &&
                      !Layout.isDisplayTablet(context))) {
                eventBus.fire(const EventCloseCustomDrawer());
              } else {
                eventBus.fire(const EventCloseNativeDrawer());
              }

              /// for fetching beforehand
              final productModel =
                  Provider.of<ProductModel>(context, listen: false);
              if (productModel.categoryId != categoryId) {
                productModel.setProductsList([], notify: false);
              }
              if (categoryId != null || listingLocationId != null) {
                productModel.fetchProductsByCategory(
                  categoryId: categoryId,
                  categoryName: categoryName,
                  listingLocationId: listingLocationId,
                  notify: false,
                );
              } else {
                productModel.setCategoryName(null);
              }

              /// override product config
              var productConfig = configValue
                ..category = categoryId
                ..tag = tagId
                ..name =
                    configValue.onSale && showCountdown ? categoryName : null
                ..showCountDown = configValue.showCountDown &&
                    configValue.onSale &&
                    showCountdown;

              /// for caching current products list from HomeCache
              if (products != null && products.isNotEmpty) {
                productModel.setProductsList(products, notify: false);

                return ProductsScreen(
                  products: products,
                  config: productConfig,
                  listingLocation: listingLocationId,
                  countdownDuration: countdownDuration,
                );
              }

              /// clear old products
              productModel.updateTagId(
                  tagId: config != null ? config['tag'] : null, notify: false);

              return ProductsScreen(
                products: products ?? [],
                config: productConfig,
                countdownDuration: countdownDuration,
                listingLocation: listingLocationId,
              );
            } catch (e, trace) {
              printError(e, trace);
              return const ProductsScreen();
            }
          });
        }
        return _errorRoute();
      case RouteList.homeSearch:
        return _buildRouteFade(
          settings,
          Services().widget.renderHomeSearchScreen(),
        );

      case RouteList.productDetail:
        Product? product;

        /// The product detail is product
        if (settings.arguments is Product) {
          product = settings.arguments as Product?;
          return _buildRoute(
            settings,
            (_) => ProductDetailScreen(product: product, id: product!.id),
          );
        }

        /// The product detail is ID
        var productId = routingData.getPram('id');
        if (productId != null) {
          return _buildRoute(
            settings,
            (_) => ProductDetailScreen(id: productId),
          );
        }
        return _errorRoute();
      case RouteList.category:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (_) => CategoriesScreen(
              key: const Key('category'),
              showSearch: data.jsonData['showSearch'] ?? true,
              enableParallax: data.jsonData['parallax'] ?? false,
              parallaxImageRatio:
                  Tools.formatDouble(data.jsonData['parallaxImageRatio']),
            ),
          );
        }
        return _buildRoute(
          settings,
          (_) => const CategoriesScreen(
            key: Key('category'),
            showSearch: true,
          ),
        );
      case RouteList.categorySearch:
        return _buildRouteFade(
          settings,
          const CategorySearch(),
        );
      case RouteList.detailBlog:
        final arguments = settings.arguments;
        if (arguments is BlogDetailArguments) {
          return _buildRoute(
            settings,
            (_) => BlogDetailScreen(
              blog: arguments.blog,
              id: arguments.id,
              listBlog: arguments.listBlog,
            ),
          );
        }
        return _errorRoute();
      case RouteList.orderDetail:
        final arguments = settings.arguments;
        if (arguments is OrderDetailArguments) {
          return _buildRoute(
            settings,
            (_) {
              return ChangeNotifierProvider<OrderHistoryDetailModel>.value(
                value: arguments.model,
                child: OrderHistoryDetailScreen(
                    enableReorder: arguments.enableReorder,
                    disableReview: arguments.disableReview),
              );
            },
          );
        }
        return _errorRoute();
      case RouteList.orders:
        final user = settings.arguments;
        return _buildRoute(
          settings,
          (_) => ChangeNotifierProvider<ListOrderHistoryModel>(
            create: (context) => ListOrderHistoryModel(
              repository: ListOrderRepository(
                  user: user == null ? User() : user as User),
            ),
            child: ListOrderHistoryScreen(),
          ),
        );
      case RouteList.search:
        return _buildRoute(
          settings,
          (_) => AutoHideKeyboard(
            child: Services().widget.renderSearchScreen(),
          ),
        );
      case RouteList.profile:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (_) => SettingScreen(
              settings: data.jsonData['settings'],
              subGeneralSetting: data.jsonData['subGeneralSetting'],
              background: data.jsonData['background'],
              drawerIcon: data.jsonData['drawerIcon'],
              hideUser: data.jsonData['hideUser'] ?? false,
            ),
          );
        }
        return _errorRoute();
      // No usage on this Route found
      // case RouteList.blog:
      //   final data = settings.arguments;
      //   if (data is Map) {
      //     return _buildRoute(
      //       settings,
      //       (_) => HorizontalSliderList(config: data as Map<String, dynamic>?),
      //     );
      //   }
      // return _errorRoute();
      case RouteList.listBlog:
        return _buildRoute(
          settings,
          (_) => ListBlogScreen(),
        );
      case RouteList.page:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (_) => WebViewScreen(
              title: data.jsonData['title'],
              url: data.jsonData['url'],
              auth: data.jsonData['auth'] ?? false,
              script: '${data.jsonData['script'] ?? ''}'.isEmptyOrNull
                  ? kAdvanceConfig.webViewScript
                  : '${data.jsonData['script'] ?? ''}',
              enableBackward: data.jsonData['enableBackward'] ?? true,
              enableForward: data.jsonData['enableForward'] ?? true,
            ),
          );
        }
        return _errorRoute();
      case RouteList.html:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (_) => StaticSite(data: data.jsonData['data']),
          );
        }
        return _errorRoute();
      case RouteList.static:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (_) => StaticPage(
              data: data.jsonData['data'] != null
                  ? Map<String, dynamic>.from(data.jsonData['data'])
                  : null,
            ),
          );
        }
        return _errorRoute();
      case RouteList.postScreen:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (_) => PostScreen(
              pageId: int.parse(data.jsonData['pageId'].toString()),
              pageTitle: data.jsonData['pageTitle'],
              isLocatedInTabbar: true,
            ),
          );
        }
        return _errorRoute();
      case RouteList.story:
        final data = settings.arguments;
        if (data is Map) {
          return _buildRoute(
            settings,
            (context) => StoryWidget(
              config: data as Map<String, dynamic>,
              isFullScreen: true,
            ),
          );
        }
        return _errorRoute();
      case RouteList.map:
        return _buildRoute(
          settings,
          (context) => Services().widget.renderMapScreen(),
        );
      case RouteList.vendorDashboard:
        return _buildRoute(
          settings,
          (context) => Services().widget.renderVendorDashBoard(),
        );
      case RouteList.vendorAdmin:
        final data = settings.arguments;
        if (data is User) {
          return _buildRoute(
              settings,
              (context) =>
                  Services().widget.getAdminVendorScreen(context, data));
        }
        return _errorRoute();
      case RouteList.delivery:

        /// If the app needs to call this route, then it definitely is from MV.
        return _buildRoute(
          settings,
          (context) => Services().widget.renderDelivery(isFromMV: true),
        );
      case RouteList.dynamic:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (context) => DynamicScreen(
                configs: data.jsonData['configs'], previewKey: data.key),
          );
        }
        return _errorRoute(data.toString());
      case RouteList.tabMenu:
        final data = settings.arguments;
        if (data is List<TabBarMenuConfig>) {
          return _buildRoute(
            settings,
            (context) => DynamicTabMenuScreen(data: data),
          );
        }
        return _errorRoute(data.toString());
      case RouteList.scrollable:
        final data = settings.arguments;
        if (data is List<TabBarMenuConfig>) {
          return _buildRoute(
            settings,
            (context) => DynamicScrollableScreen(data: data),
          );
        }
        return _errorRoute(data.toString());
      case RouteList.pageTab:
        final data = settings.arguments;
        if (data is TabBarMenuConfig) {
          return _buildRoute(
            settings,
            (context) => PageTabScreen(data),
          );
        }
        return _errorRoute(data.toString());
      case RouteList.home:
        return _buildRoute(
          settings,
          (context) => const HomeScreen(),
        );
      case RouteList.onBoarding:
        return _buildRoute(
          settings,
          (context) => const OnBoardScreen(),
        );
      case RouteList.cart:
        final cartArgument = settings.arguments;
        if (cartArgument is CartScreenArgument) {
          return _buildRoute(
            settings,
            (context) => CartScreen(
              isBuyNow: cartArgument.isBuyNow,
              isModal: cartArgument.isModal,
              hideNewAppBar: cartArgument.hideNewAppBar,
            ),
            fullscreenDialog: true,
          );
        }
        return _buildRoute(
          settings,
          (context) => const CartScreen(),
        );
      case RouteList.postManagement:
        return _buildRoute(
          settings,
          (context) => Services().widget.renderPostManagementScreen(),
        );
      case RouteList.checkout:
        final argument = settings.arguments;
        if (argument is CheckoutArgument) {
          return _buildRoute(
            settings,
            (context) => Checkout(isModal: argument.isModal),
          );
        }
        return _errorRoute();
      case RouteList.subCategories:
        final arguments = settings.arguments;
        if (arguments is SubcategoryArguments) {
          final subcategoryModel =
              SubcategoryModel(parentId: arguments.parentId)..getData();
          return _buildRoute(
            settings,
            (context) => ChangeNotifierProvider.value(
              value: subcategoryModel,
              child: ChangeNotifierProvider.value(
                value: subcategoryModel.listSubcategoryModel,
                child: SubcategoryScreen(
                  categoryName: arguments.categoryName,
                  level: arguments.level,
                ),
              ),
            ),
          );
        }
        return _errorRoute();
      case RouteList.updateUser:
        if (ServerConfig().isWooType) {
          return _buildRoute(settings, (context) => UserUpdateWooScreen());
        }
        return _buildRoute(settings, (context) => UserUpdateScreen());
      case RouteList.deleteAccount:
        final arguments = settings.arguments;
        if (arguments is! DeleteAccountArguments) {
          return _errorRoute();
        }
        return _buildRoute(
          settings,
          (context) => DeleteAccountScreen(
            confirmCaptcha: arguments.confirmCaptcha,
            userToken: arguments.userToken,
          ),
        );
      case RouteList.productReviews:
        final arguments = settings.arguments;
        if (arguments is Product) {
          final product = arguments;
          return _buildRoute(
            settings,
            (context) => ChangeNotifierProvider(
              create: (context) => ProductReviewsModel(product),
              child: ProductReviewScreen(product: product),
            ),
          );
        }
        return _errorRoute();
      case RouteList.brandList:
        final arguments = settings.arguments;
        if (arguments is BrandListLayoutArgs) {
          final brandArgs = arguments;
          return _buildRoute(
            settings,
            (context) => BrandListLayout(args: brandArgs),
          );
        }
        return _errorRoute();
      case RouteList.geoSearch:
        final arguments = settings.arguments;
        if (arguments is GeoSearchArgs) {
          final geoSearchArgs = arguments;
          return _buildRoute(
            settings,
            (context) => GeoSearchScreen(stores: geoSearchArgs.stores),
          );
        }
        return _errorRoute();
      default:
        final allRoutes = {
          ...getAll(),
          ...Services().getWalletRoutesWithSettings(settings),
          ...Services().getMembershipUltimateRoutesWithSettings(settings),
          ...Services().getPaidMembershipProRoutesWithSettings(settings),
          ...Services().getPOSRoutesWithSettings(settings),
          ...Services().getDigitsMobileLoginRoutesWithSettings(settings)
        };
        if (allRoutes.containsKey(settings.name)) {
          return _buildRoute(
            settings,
            allRoutes[settings.name!]!,
          );
        }

        if (ServerConfig().isVendorType()) {
          return _buildRoute(settings, Services().getVendorRoute(settings));
        }
        return _errorRoute();
    }
  }

  static WidgetBuilder? getRouteByName(String name) {
    if (_routes.containsKey(name) == false) {
      return _routes[RouteList.login];
    }
    return _routes[name];
  }

  static Route _errorRoute([String message = 'Page not founds']) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      );
    });
  }

  static PageRouteBuilder _buildRouteFade(
    RouteSettings settings,
    Widget builder,
  ) {
    return _FadedTransitionRoute(
      settings: settings,
      widget: builder,
    );
  }

  static MaterialPageRoute _buildRoute(
      RouteSettings settings, WidgetBuilder builder,
      {bool fullscreenDialog = false}) {
    return MaterialPageRoute(
      settings: settings,
      builder: builder,
      fullscreenDialog: fullscreenDialog,
    );
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget? widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({this.widget, required this.settings})
      : super(
          settings: settings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget!;
          },
          transitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        );
}
