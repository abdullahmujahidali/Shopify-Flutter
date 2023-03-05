import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/widgets/expandable/expansion_widget.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../generated/l10n.dart';
import '../models/entities/filter_sorty_by.dart';
import '../models/index.dart';
import '../modules/dynamic_layout/index.dart';
import '../modules/dynamic_layout/product/product_list.dart';
import '../screens/categories/layouts/multi_level.dart';
import '../screens/categories/layouts/parallax.dart';
import '../screens/categories/layouts/side_menu_with_group.dart';
import '../screens/checkout/widgets/payment_method_item.dart';
import '../screens/index.dart';
import '../services/index.dart';
import '../widgets/cardlist/index.dart';
import '../widgets/common/group_check_box_widget.dart';
import '../widgets/common/webview.dart';
import '../widgets/html/index.dart';
import '../widgets/orders/tracking.dart';
import '../widgets/product/product_card_view.dart';
import '../widgets/product/product_glass_view.dart';
import '../widgets/product/product_item_tile.dart';
import 'wordpress/presentation/widgets/index.dart'
    show BlogListLayout, CommentInput, CommentLayout, RelatedBlogList;

abstract class BaseFrameworks {
  bool get enableProductReview => false;

  bool get isEnabledProductBottomSheet => kAdvanceConfig.enableCart;

  bool get isRequiredLogin => kLoginSetting.isRequiredLogin;

  bool get enableMembershipUltimate => false;

  bool enableShoppingCart(Product? product) => kAdvanceConfig.enableCart;
  bool get enableInAppPurchase => false;

  Future<void> doCheckout(
    BuildContext context, {
    Function? success,
    Function? error,
    Function? loading,
  }) async {}

  Future<void> applyCoupon(
    BuildContext context, {
    Coupons? coupons,
    String? code,
    Function? success,
    Function? error,
  }) async {}

  Future<void>? removeCoupon(BuildContext context) => null;

  Future<void> createOrder(BuildContext context,
      {Function? onLoading,
      Function? success,
      Function? error,
      bool paid = false,
      bool cod = false,
      bool bacs = false,
      String transactionId = ''}) async {}

  void placeOrder(
    BuildContext context, {
    CartModel? cartModel,
    PaymentMethod? paymentMethod,
    Function? onLoading,
    Function? success,
    Function? error,
  }) async {}

  Map<dynamic, dynamic>? getPaymentUrl(context) => null;

  /// For Cart Screen
  Widget renderCartPageView({
    BuildContext? context,
    bool? isModal,
    bool? isBuyNow,
    PageController? pageController,
  }) =>
      const SizedBox();

  Widget renderVariantCartItem(
    BuildContext context,
    ProductVariation variation,
    Map? options,
  ) =>
      const SizedBox();

  String? getPriceItemInCart(
    Product product,
    ProductVariation? variation,
    Map<String, dynamic> currencyRate,
    String? currency, {
    List<AddonsOption>? selectedOptions,
  }) =>
      null;

  /// For Update User Screen
  void updateUserInfo({
    User? loggedInUser,
    BuildContext? context,
    required Function onError,
    Function? onSuccess,
    required String currentPassword,
    required String userDisplayName,
    String? userEmail,
    String? userNiceName,
    String? userUrl,
    String? userPassword,
    String? userFirstname,
    String? userLastname,
  });

  Widget renderCurrentPassInputforEditProfile({
    BuildContext? context,
    TextEditingController? currentPasswordController,
  }) =>
      const SizedBox();

  /// For app model
  Future<void>? onLoadedAppConfig(String? lang, Function callback) => null;

  /// For app model
  Future<AppConfig?> onGetAppConfig(String lang) async => null;

  /// For Shipping Address checkout
  void loadShippingMethods(
    BuildContext context,
    CartModel cartModel,
    bool beforehand,
  ) {}

  Widget renderButtons(
    BuildContext context,
    Order order,
    cancelOrder,
    createRefund,
  ) =>
      const SizedBox();

  /// For product variant
  Future<void> getProductVariations({
    BuildContext? context,
    Product? product,
    void Function({
      Product? productInfo,
      List<ProductVariation>? variations,
      Map<String?, String?> mapAttribute,
      ProductVariation? variation,
    })?
        onLoad,
  }) async =>
      {};

  Future<void> getProductAddons({
    required BuildContext context,
    required Product product,
    required Function(
            {Product? productInfo,
            required Map<String, Map<String, AddonsOption>> selectedOptions})
        onLoad,
    required Map<String, Map<String, AddonsOption>> selectedOptions,
  }) async {}

  // bool couldBePurchased(
  //   List<ProductVariation>? variations,
  //   ProductVariation? productVariation,
  //   Product product,
  //   Map<String?, String?>? mapAttribute,
  // ) => false;

  void onSelectProductVariant({
    required ProductAttribute attr,
    String? val,
    required List<ProductVariation> variations,
    required Map<String?, String?> mapAttribute,
    required Function onFinish,
  }) {}

  List<Widget> getProductAttributeWidget(
    String lang,
    Product product,
    Map<String?, String?>? mapAttribute,
    Function onSelectProductVariant,
    List<ProductVariation> variations,
  ) =>
      [const SizedBox()];

  List<Widget> getProductAddonsWidget({
    required BuildContext context,
    String? lang,
    required Product product,
    required Map<String, Map<String, AddonsOption>> selectedOptions,
    Function? onSelectProductAddons,
    int quantity = 1,
  }) {
    return const [SizedBox()];
  }

  List<Widget> getProductTitleWidget(
    BuildContext context,
    ProductVariation? productVariation,
    Product product,
  ) =>
      [const SizedBox()];

  List<Widget> getBuyButtonWidget(
    BuildContext context,
    ProductVariation? productVariation,
    Product product,
    Map<String?, String?>? mapAttribute,
    int maxQuantity,
    int quantity,
    Function addToCart,
    Function onChangeQuantity,
    List<ProductVariation>? variations,
    bool isInAppPurchaseChecking,
  ) =>
      [const SizedBox()];

  void addToCart(BuildContext context, Product product, int quantity,
      ProductVariation? productVariation, Map<String?, String?> mapAttribute,
      [bool buyNow = false, bool inStock = false, bool inBackground = false]) {}

  /// Load countries for shipping address
  Future<List<Country>?> loadCountries();

  /// Load states for shipping address
  Future<List<CountryState>> loadStates(Country country);

  /// Load cities for shipping address
  Future<List<City>>? loadCities(Country country, CountryState state) => null;

  /// Load zipCode for shipping address
  Future<String>? loadZipCode(Country country, CountryState state, City city) =>
      null;

  Future<void>? resetPassword(BuildContext context, String username) => null;

  Widget renderShippingPaymentTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.secondary),
    );
  }

  Future<Product?>? getProductDetail(
    BuildContext context,
    Product? product,
  ) async =>
      product;

//Sync cart from website
  Future<void>? syncCartFromWebsite(
          String? token, CartModel cartModel, BuildContext context) =>
      null;

//Sync cart to website
  Future<void>? syncCartToWebsite(CartModel cartModel) => null;

  Widget renderTaxes(TaxModel taxModel, BuildContext context) {
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;
    final currency =
        Provider.of<CartModel>(context, listen: false).currencyCode;

    if (taxModel.taxes != null && taxModel.taxes!.isNotEmpty) {
      var list = <Widget>[];
      for (var element in taxModel.taxes!) {
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              element.title!,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              PriceTools.getCurrencyFormatted(element.amount, currencyRate,
                  currency: currency)!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          children: list,
        ),
      );
    } else if (taxModel.taxesTotal > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).tax,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              PriceTools.getCurrencyFormatted(taxModel.taxesTotal, currencyRate,
                  currency: currency)!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  /// For Vendor
  Product updateProductObject(Product product, Map? json) => product;

  void onFinishOrder(
    BuildContext context,
    Function onSuccess,
    Order order,
  ) {
    onSuccess();
  }

  /// render vendor default on product detail screen
  Widget renderVendorInfo(Product? product) => const SizedBox();

  /// vendor menu order from vendor on Setting page
  Widget renderVendorOrder(BuildContext context) => const SizedBox();

  /// feature vendor on home screen
  Widget renderFeatureVendor(config) => const SizedBox();

  ///render shipping methods screen when checkout
  Widget renderShippingMethods(
    BuildContext context, {
    Function? onBack,
    Function? onNext,
  }) {
    return ShippingMethods(onBack: onBack, onNext: onNext);
  }

  /// render screen for Category Vendor
  Widget renderVendorCategoriesScreen(data) => const SizedBox();

  Widget renderCategoryLayout({
    required String layout,
    bool enableParallax = false,
    double? parallaxImageRatio,
    ScrollController? scrollController,
  }) {
    switch (layout) {
      case CardCategories.type:
        return CardCategories(
          enableParallax: enableParallax,
          parallaxImageRatio: parallaxImageRatio,
          scrollController: scrollController,
        );
      case ColumnCategories.type:
        return ColumnCategories(
          scrollController: scrollController,
        );
      case SubCategories.type:
        return SubCategories(
          scrollController: scrollController,
        );
      case SideMenuCategories.type:
        return const SideMenuCategories();
      case SideMenuSubCategories.type:
        return const SideMenuSubCategories();
      case SideMenuGroupCategories.type:
        return const SideMenuGroupCategories();
      case GridCategory.type:
        return GridCategory(
          scrollController: scrollController,
        );
      case ParallaxCategories.type:
        //   return const ParallaxCategories();
        return CardCategories(
          enableParallax: true,
          parallaxImageRatio: parallaxImageRatio,
          scrollController: scrollController,
        );
      case MultiLevelCategories.type:
        return const MultiLevelCategories();
      case HorizonMenu.type:
      default:
        return HorizonMenu(
          scrollController: scrollController,
        );
    }
  }

  /// render screen for Map
  Widget renderMapScreen() => const SizedBox();

  ///render shipping method info in review screen
  Widget renderShippingMethodInfo(BuildContext context) {
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final model = Provider.of<CartModel>(context);

    return model.isEnabledShipping() && model.shippingMethod != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Services().widget.renderShippingPaymentTitle(
                        context,
                        model.shippingMethod!.title.toString(),
                      ),
                ),
                Text(
                  PriceTools.getCurrencyFormatted(
                      model.getShippingCost(), currencyRate,
                      currency: model.currencyCode)!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                )
              ],
            ),
          )
        : const SizedBox();
  }

  ///render reward info in review screen
  Widget renderRewardInfo(BuildContext context) {
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;
    final currency = Provider.of<AppModel>(context, listen: false).currency;
    final rewardTotal =
        Provider.of<CartModel>(context, listen: false).rewardTotal;

    if (rewardTotal > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).cartDiscount,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              PriceTools.getCurrencyFormatted(rewardTotal, currencyRate,
                  currency: currency)!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }

  /// render Search Screen
  Widget renderSearchScreen() {
    return ChangeNotifierProvider<SearchModel>(
      create: (context) => SearchModel(),
      builder: (context, _) {
        return SearchScreen(
          autoFocusSearch: false,
          key: const Key('search'),
          isModal: Navigator.canPop(context),
        );
      },
    );
  }

  /// get country name
  Future<String?> getCountryName(context, countryCode) async {
    return CountryPickerUtils.getCountryByIsoCode(countryCode).name;
  }

  /// get admin vendor url
  Widget getAdminVendorScreen(context, dynamic user) {
    /// Force user to try out the new native store management.
    if (!kVendorConfig.disableNativeStoreManagement) {
      return Services().getVendorAdminApp(
        user: user,
        isFromMV: true,
      );
    }

    return const SizedBox();
  }

  /// get delivery
  Widget? getDeliveryScreen(context, dynamic user) {
    return const SizedBox();
  }

  ///render timeline tracking on order detail screen
  Widget renderOrderTimelineTracking(BuildContext context, Order order) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            S.of(context).status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.center,
          child: TimelineTracking(
            axisTimeLine: kIsWeb ? Axis.horizontal : Axis.vertical,
            status: order.status!.content,
            createdAt: order.createdAt,
            dateModified: order.dateModified,
          ),
        ),
      ],
    );
  }

  ///----- For FluxStore Listing -----///
  /// render Booking History
  Widget renderBookingHistory(context) => const SizedBox();

  /// render Add new Listing screen
  Widget renderNewListing(context) => const SizedBox();

  /// render the Product or Listing Detail screen
  Widget renderDetailScreen(
    BuildContext context,
    Product product,
    String layoutType,
    bool isLoading, {
    ScrollController? scrollController,
  }) {
    Services().firebase.firebaseAnalytics?.logViewItem(
          currency: Provider.of<AppModel>(context, listen: false).currency,
          data: product,
          price: double.tryParse(product.price ?? ''),
        );

    switch (layoutType) {
      case 'halfSizeImageType':
        return HalfSizeLayout(product: product, isLoading: isLoading);
      case 'fullSizeImageType':
        return FullSizeLayout(product: product, isLoading: isLoading);
      default:
        return SimpleLayout(
          product: product,
          isLoading: isLoading,
          scrollController: scrollController,
        );
    }
  }

  /// render product card view widget
  Widget renderProductCardView({
    Product? item,
    double? width,
    double? maxWidth,
    double? height,
    double? ratioProductImage = 1.2,
    required ProductConfig config,
  }) {
    if (item == null) {
      return const SizedBox();
    }
    if (config.cardDesign == CardDesign.glass) {
      return ProductGlass(
        item: item,
        width: width,
        maxWidth: maxWidth,
        config: config..imageRatio = ratioProductImage ?? 1.2,
      );
    }
    return ProductCard(
      item: item,
      width: width,
      maxWidth: maxWidth,
      config: config..imageRatio = ratioProductImage ?? 1.2,
    );
  }

  /// render product item tile view
  Widget renderProductItemTileView({
    required Product item,
    EdgeInsets? padding,
    required ProductConfig config,
  }) {
    return ProductItemTileView(
      item: item,
      padding: padding,
      config: config,
    );
  }

  /// render product glass card
  Widget renderProductGlassView({
    required Product item,
    required double width,
    required ProductConfig config,
  }) {
    return ProductGlass(
      item: item,
      width: width,
      config: config,
    );
  }

  /// render vendor dashboard
  Widget renderVendorDashBoard() => const SizedBox();

  Widget renderDelivery({bool isFromMV = false}) => const SizedBox();

  /// render vendor dashboard
  Widget renderAddonsOptionsCartItem(
    context,
    List<AddonsOption>? selectedOptions,
  ) {
    return const SizedBox();
  }

  /// render Vendor from config banner
  Widget renderVendorScreen(String? storeID) => const SizedBox();

  /// Support Affiliate product
  void openExternal(BuildContext context, Product product) async {
    final url = Tools.prepareURL(product.affiliateUrl);

    if (url != null) {
      try {
        if (Tools.needToOpenExternalApp(url)) {
          await Tools.launchURL(url);
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebView(
                url: product.affiliateUrl,
                title: product.name,
              ),
            ),
          );
        }
        return;
      } catch (e) {
        printError(e);
      }
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(
          child: Text(S.of(context).notFound),
        ),
      );
    }));
  }

  Future? getHomeCache(String lang) => null;

  Future createReview({
    String? productId,
    Map<String, dynamic>? data,
  }) async {}

  Future<List<OrderNote>?> getOrderNote({
    UserModel? userModel,
    dynamic orderId,
  }) async =>
      null;

  /// For booking feature
  Future<Map<String, dynamic>>? getCurrencyRate() => null;

  Future<bool>? createBooking(dynamic bookingInfo) => null;

  Future<List<dynamic>>? getListStaff(String idProduct) => null;

  Future<List<String>>? getSlotBooking(
    String idProduct,
    String idStaff,
    String date,
  ) =>
      null;

  Widget renderOptionsCartItem(Product product, Map? options) {
    return const SizedBox();
  }

  /// FluxNews: Render LargeCardHorizontalListItems widget
  Widget renderLargeCardHorizontalListItems(Map<String, dynamic> config) =>
      ProductListLargeCard(
        config: ProductConfig.fromJson(config),
      );

  /// FluxNews: Render SliderList widget
  Widget renderSliderList(Map<String, dynamic>? config) => const SizedBox();

  /// FluxNews: Render SliderItem widget
  Widget renderSliderItem(Map<String, dynamic>? config) => const SizedBox();

  Widget renderHorizontalListItem(Map<String, dynamic> config,
      {cleanCache = false}) {
    if (config['type'] == 'blog') {
      return BlogListLayout(
        config: BlogConfig.fromJson(config),
      );
    }
    return ProductList(
      config: ProductConfig.fromJson(config),
      cleanCache: cleanCache,
    );
  }

  Widget renderVerticalLayout(
      Map<String, dynamic> config, bool enableScrollView) {
    return VerticalLayout(config: config, enableScrollView: enableScrollView);
  }

  Widget renderPostManagementScreen() => const SizedBox();

  Widget renderWishListScreen() => const ProductWishListScreen();

  Widget renderHomeSearchScreen() => ChangeNotifierProvider(
        create: (context) => SearchModel(),
        child: const SearchScreen(),
      );

  Widget renderCommentLayout(dynamic postId, kBlogLayout type) {
    return CommentLayout(
      postId: postId,
      type: type,
    );
  }

  Widget renderCommentField(dynamic postId) {
    return CommentInput(blogId: postId);
  }

  Widget renderRelatedBlog({categoryId, required kBlogLayout type}) {
    return RelatedBlogList(
      categoryId: categoryId,
      type: type,
    );
  }

  Widget renderDetailPrice(
      BuildContext context, Product product, String? price) {
    final currency = Provider.of<AppModel>(context, listen: false).currency;
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;
    return Text(
      product.type != 'grouped'
          ? PriceTools.getCurrencyFormatted(price ?? '0.0', currencyRate,
              currency: currency)!
          : Provider.of<ProductModel>(context).detailPriceRange,
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget renderRecurringTotals(BuildContext context) => const SizedBox();

  Widget renderGeoSearch(Map<String, dynamic> config) => const SizedBox();

  Widget renderVacationVendor(String userId, String cookie,
          {bool isFromMV = true}) =>
      const SizedBox();

  Widget renderPayByWallet(BuildContext context) => const SizedBox();

  Widget renderCheckoutWalletInfo(BuildContext context) => const SizedBox();

  Future updateOrderAfterCheckout(BuildContext context, Order order) async {}

  Widget renderPaymentMethodItem(
          BuildContext context,
          PaymentMethod paymentMethod,
          Function(String?) onSelected,
          String? selectedId) =>
      PaymentMethodItem(
          paymentMethod: paymentMethod,
          onSelected: onSelected,
          selectedId: selectedId);

  Widget renderProductDescription(
    BuildContext context,
    String description,
  ) {
    return HtmlWidget(
      description.replaceAll('src="//', 'src="https://'),
      textStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(
            color: Theme.of(context).colorScheme.secondary,
            height: 1.5,
          )
          .apply(
            fontSizeFactor: 1.1,
          ),
    );
  }

  Widget reOrderButton(Order order) {
    return const SizedBox();
  }

  Widget productReviewWidget(Product product) {
    return const SizedBox();
  }

  List<SingleChildWidget> getExtraProvidersConfig() => [];

  List<OrderByType> get supportedSortByOptions => [
        OrderByType.onSale,
        OrderByType.featured,
        OrderByType.date,
        OrderByType.price
      ];

  Widget renderFilterSortBy(
    BuildContext context, {
    FilterSortBy? filterSortBy,
    required Function(FilterSortBy? filterSortBy) onFilterChanged,
    bool showDivider = true,
    bool isBlog = false,
  }) {
    if (isBlog) {
      return ExpansionWidget(
        showDivider: showDivider,
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: 10,
        ),
        title: Text(
          S.of(context).sortBy,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        children: [
          GroupCheckBoxWidget<String>(
            numberOfRow: 2,
            childAspectRatio: 16 / 4,
            defaultValue: filterSortBy?.groupOrderBy,
            onChanged: (selectedItem) {
              final filterData = selectedItem?.value.split('-');
              final orderBy = filterData?[0];
              final order = filterData?[1];
              filterSortBy =
                  filterSortBy?.applyOrderBy(orderBy).applyOrder(order);
              onFilterChanged(filterSortBy);
            },
            values: <GroupCheckBoxItem<String>>{
              GroupCheckBoxItem(
                title: S.of(context).dateLatest,
                value: 'date-desc',
              ),
              GroupCheckBoxItem(
                title: S.of(context).dateOldest,
                value: 'date-asc',
              ),
            },
          ),
        ],
      );
    }
    return ExpansionWidget(
      showDivider: showDivider,
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
        bottom: 10,
      ),
      title: Text(
        S.of(context).sortBy,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      children: [
        if ([OrderByType.onSale, OrderByType.featured]
            .any((element) => supportedSortByOptions.contains(element))) ...[
          GroupCheckBoxWidget<String>(
            numberOfRow: 2,
            childAspectRatio: 16 / 4,
            defaultValue: filterSortBy?.groupSpecial,
            onChanged: (selectedItem) {
              final value = selectedItem?.value;
              if (value == null) {
                filterSortBy =
                    filterSortBy?.applyOnSale(null).applyFeatured(null);
              } else if (value == 'onSale') {
                filterSortBy =
                    filterSortBy?.applyOnSale(true).applyFeatured(null);
              } else if (value == 'featured') {
                filterSortBy =
                    filterSortBy?.applyFeatured(true).applyOnSale(null);
              }
              onFilterChanged(filterSortBy);
            },
            values: <GroupCheckBoxItem<String>>{
              if (supportedSortByOptions.contains(OrderByType.onSale))
                GroupCheckBoxItem(
                  title: S.of(context).onSale,
                  value: 'onSale',
                ),
              if (supportedSortByOptions.contains(OrderByType.featured))
                GroupCheckBoxItem(
                  title: S.of(context).featured,
                  value: 'featured',
                ),
            },
          ),
          const Divider(),
        ],
        GroupCheckBoxWidget<String>(
          numberOfRow: 2,
          childAspectRatio: 16 / 4,
          defaultValue: filterSortBy?.groupOrderBy,
          onChanged: (selectedItem) {
            final filterData = selectedItem?.value.split('-');
            final orderBy = filterData?[0];
            final order = filterData?[1];
            filterSortBy =
                filterSortBy?.applyOrderBy(orderBy).applyOrder(order);
            onFilterChanged(filterSortBy);
          },
          values: <GroupCheckBoxItem<String>>{
            if (supportedSortByOptions.contains(OrderByType.date)) ...[
              GroupCheckBoxItem(
                title: S.of(context).dateLatest,
                value: 'date-desc',
              ),
              GroupCheckBoxItem(
                title: S.of(context).dateOldest,
                value: 'date-asc',
              ),
            ],
            if (supportedSortByOptions.contains(OrderByType.price)) ...[
              GroupCheckBoxItem(
                title: S.of(context).priceLowToHigh,
                value: 'price-asc',
              ),
              GroupCheckBoxItem(
                title: S.of(context).priceHighToLow,
                value: 'price-desc',
              ),
            ],
            if (supportedSortByOptions.contains(OrderByType.title)) ...[
              GroupCheckBoxItem(
                title: S.of(context).titleAToZ,
                value: 'title-asc',
              ),
              GroupCheckBoxItem(
                title: S.of(context).titleZToA,
                value: 'title-desc',
              ),
            ],
            if (supportedSortByOptions.contains(OrderByType.menu_order))
              GroupCheckBoxItem(
                title: S.of(context).menuOrder,
                value: 'menu_order-asc',
              ),
            if (supportedSortByOptions.contains(OrderByType.popularity))
              GroupCheckBoxItem(
                title: S.of(context).popularity,
                value: 'popularity-null',
              ),
            if (supportedSortByOptions.contains(OrderByType.rating))
              GroupCheckBoxItem(
                title: S.of(context).averageRating,
                value: 'rating-null',
              ),
          },
        ),
      ],
    );
  }

  Widget renderCODExtraFee(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    final enabled = (kPaymentConfig.smartCOD?.enabled ?? false) &&
        ((cartModel.paymentMethod?.id?.contains('cod') ?? false) ||
            (cartModel.paymentMethod?.id?.contains('cashondelivery') ?? false));
    final extraFee = kPaymentConfig.smartCOD?.extraFee ?? 0;
    final amountStop = kPaymentConfig.smartCOD?.amountStop ?? 0;
    final subtotal = cartModel.getSubTotal() ?? 0;

    if (enabled && extraFee > 0 && subtotal < amountStop) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).codExtraFee,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              PriceTools.getCurrencyFormatted(extraFee, cartModel.currencyRates,
                  currency: cartModel.currencyCode)!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
