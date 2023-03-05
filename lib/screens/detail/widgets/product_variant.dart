import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools/flash.dart';
import '../../../common/tools/tools.dart';
import '../../../generated/l10n.dart' show S;
import '../../../models/index.dart'
    show
        AddonsOption,
        AppModel,
        Product,
        ProductAttribute,
        ProductModel,
        ProductVariation;
import '../../../services/index.dart';
import '../../../widgets/common/webview.dart';

class ProductVariant extends StatefulWidget {
  final Product? product;
  final Function? onSelectVariantImage;
  final int defaultQuantity;

  const ProductVariant(this.product,
      {this.onSelectVariantImage, this.defaultQuantity = 1});

  @override
  // ignore: no_logic_in_create_state
  State<ProductVariant> createState() => _StateProductVariant(product!);
}

class _StateProductVariant extends State<ProductVariant> {
  Product product;

  ProductVariation? productVariation;

  Map<String, Map<String, AddonsOption>> selectedOptions = {};
  List<AddonsOption> addonsOptions = [];

  _StateProductVariant(this.product);

  final services = Services();
  Map<String?, String?>? mapAttribute;

  List<ProductVariation>? get variations =>
      context.select((ProductModel _) => _.variations);

  int quantity = 1;

  bool isInAppPurchaseChecking = false;

  void updateSelectedOptions(
      Map<String, Map<String, AddonsOption>> selectedOptions) {
    this.selectedOptions = selectedOptions;
    final options = <AddonsOption>[];
    for (var addOns in selectedOptions.values) {
      options.addAll(addOns.values);
    }
    product.selectedOptions = options;
  }

  /// Get product variants
  Future<void> getProductVariations() async {
    await services.widget.getProductVariations(
        context: context,
        product: product,
        onLoad: ({
          Product? productInfo,
          List<ProductVariation>? variations,
          Map<String?, String?>? mapAttribute,
          ProductVariation? variation,
        }) {
          if (productInfo != null) {
            product = productInfo;
          }
          this.mapAttribute = mapAttribute ?? {};
          if (variations != null) {
            context.read<ProductModel>().changeProductVariations(
                  variations,
                  notify: false,
                );
            productVariation = variation;
            context
                .read<ProductModel>()
                .changeSelectedVariation(productVariation);
          }
          if (!mounted) {
            return;
          }
          setState(() {});
        });
  }

  Future<void> getProductAddons() async {
    await services.widget.getProductAddons(
      context: context,
      product: product,
      selectedOptions: selectedOptions,
      onLoad: (
          {Product? productInfo,
          required Map<String, Map<String, AddonsOption>> selectedOptions}) {
        if (productInfo != null) {
          product = productInfo;
        }
        updateSelectedOptions(selectedOptions);
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    product = widget.product as Product;
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) {
          setState(() {
            quantity = widget.defaultQuantity;
          });
          getProductVariations();
          getProductAddons();
        }
      },
    );
  }

  @override
  void dispose() {
    FlashHelper.dispose();
    Services().iapDispose();
    super.dispose();
  }

  /// Support Affiliate product
  Future<void> openExternal() async {
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

  /// Add to Cart & Buy Now function
  void addToCart([bool buyNow = false, bool inStock = false]) {
    if (buyNow &&
        Services().widget.enableInAppPurchase &&
        !ServerConfig().isBuilder) {
      Services().doIAPPayment(
          context, product, productVariation, quantity, mapAttribute ?? {},
          (bool isLoading) {
        setState(() {
          isInAppPurchaseChecking = isLoading;
        });
      }, () {
        services.widget.addToCart(context, product, quantity, productVariation,
            mapAttribute ?? {}, buyNow, inStock);
      });
    } else {
      services.widget.addToCart(context, product, quantity, productVariation,
          mapAttribute ?? {}, buyNow, inStock);
    }
  }

  /// check limit select quality by maximum available stock
  int getMaxQuantity() {
    var limitSelectQuantity = kCartDetail['maxAllowQuantity'] ?? 100;

    /// Skip check stock quantity for backorder products.
    if (product.backordersAllowed) {
      return limitSelectQuantity;
    }

    if (productVariation != null) {
      if (productVariation!.stockQuantity != null) {
        limitSelectQuantity = math.min<int>(
            productVariation!.stockQuantity!, kCartDetail['maxAllowQuantity']);
      }
    } else if (product.stockQuantity != null) {
      limitSelectQuantity = math.min<int>(
          product.stockQuantity!, kCartDetail['maxAllowQuantity']);
    }
    return limitSelectQuantity;
  }

  void onSelectProductVariant({
    ProductAttribute? attr,
    String? val,
    List<ProductVariation>? variations,
    Map<String?, String?>? mapAttribute,
    Function? onFinish,
  }) {
    services.widget.onSelectProductVariant(
      attr: attr!,
      val: val,
      variations: variations!,
      mapAttribute: mapAttribute!,
      onFinish:
          (Map<String?, String?> mapAttribute, ProductVariation? variation) {
        setState(() {
          this.mapAttribute = mapAttribute;
        });
        productVariation = variation;
        context.read<ProductModel>().changeSelectedVariation(variation);

        /// Show selected product variation image in gallery.
        final attrType = kProductVariantLayout[attr.cleanSlug ?? attr.name] ??
            kProductVariantLayout[attr.name!.toLowerCase()] ??
            'box';
        if (widget.onSelectVariantImage != null && attrType == 'image') {
          for (var option in attr.options!) {
            if (option['name'] == val &&
                option['description'].toString().contains('http')) {
              final selectedImageUrl = option['description'];
              widget.onSelectVariantImage!(selectedImageUrl);
            }
          }
        }
      },
    );
  }

  void onSelectProductAddons({
    required Map<String, Map<String, AddonsOption>> selectedOptions,
  }) {
    setState(() {
      updateSelectedOptions(selectedOptions);
    });
  }

  List<Widget> getProductAttributeWidget() {
    final lang = Provider.of<AppModel>(context, listen: false).langCode;
    if (mapAttribute == null && ServerConfig().type != ConfigType.opencart) {
      return [];
    }
    return services.widget.getProductAttributeWidget(
        lang, product, mapAttribute, onSelectProductVariant, variations!);
  }

  List<Widget> getProductAddonsWidget() {
    final lang = Provider.of<AppModel>(context, listen: false).langCode;
    return services.widget.getProductAddonsWidget(
      context: context,
      selectedOptions: selectedOptions,
      lang: lang,
      product: product,
      onSelectProductAddons: onSelectProductAddons,
      quantity: quantity,
    );
  }

  List<Widget> getBuyButtonWidget() {
    return services.widget.getBuyButtonWidget(context, productVariation,
        product, mapAttribute, getMaxQuantity(), quantity, addToCart, (val) {
      quantity = val;
    }, variations, isInAppPurchaseChecking);
  }

  List<Widget> getProductTitleWidget() {
    return services.widget
        .getProductTitleWidget(context, productVariation, product);
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    final isVariationLoading = productVariation == null &&
        (variations?.isEmpty ?? true) &&
        ServerConfig().type != ConfigType.opencart &&
        ServerConfig().type != ConfigType.notion;

    return Column(
      children: <Widget>[
        ...getProductTitleWidget(),
        if (!isVariationLoading) ...getProductAttributeWidget(),
        ...getProductAddonsWidget(),
        ...getBuyButtonWidget(),
      ],
    );
  }
}
