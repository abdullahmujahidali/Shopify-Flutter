import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../index.dart';

mixin CartMixin {
  User? user;
  double taxesTotal = 0;
  List<Tax> taxes = [];
  double rewardTotal = 0;
  double walletAmount = 0;

  PaymentMethod? paymentMethod;

  String? notes;
  String? currencyCode;
  Map<String, dynamic>? currencyRates;

  final Map<String?, Product?> item = {};

  final Map<String, ProductVariation?> productVariationInCart = {};

  final Map<String, List<AddonsOption>?> productAddonsOptionsInCart = {};

  // The IDs and quantities of products currently in the cart.
  final Map<String, int?> productsInCart = {};

  // The IDs and meta_data of products currently in the cart for woo commerce
  final Map<String, dynamic> productsMetaDataInCart = {};

  void removeItemFromProductId(String productId) {}

  int get totalCartQuantity => productsInCart.values.fold(0, (v, e) => v + e!);

  bool _hasProductVariation(String id) =>
      productVariationInCart[id] != null &&
      productVariationInCart[id]!.price != null &&
      productVariationInCart[id]!.price!.isNotEmpty;

  double getProductPrice(id) {
    if (_hasProductVariation(id)) {
      return double.parse(productVariationInCart[id]!.price!) *
          productsInCart[id]!;
    } else {
      var productId = Product.cleanProductID(id);

      var price =
          PriceTools.getPriceProductValue(item[productId], onSale: true);
      if ((price?.isNotEmpty ?? false) && productsInCart[id] != null) {
        return double.parse(price!) * productsInCart[id]!;
      }
      return 0.0;
    }
  }

  double getProductAddonsPrice(String id) {
    if (productAddonsOptionsInCart.isNotEmpty) {
      var price = 0.0;
      if (productAddonsOptionsInCart[id] == null) {
        return 0.0;
      }
      for (var option in productAddonsOptionsInCart[id]!) {
        var quantity = productsInCart[id] ?? 0;
        var optionPrice = (double.tryParse(option.price ?? '0.0') ?? 0.0);
        if (option.isQuantityBased) {
          optionPrice *= quantity;
        }
        price += optionPrice;
      }
      return price;
    }
    return 0.0;
  }

  double? getSubTotal() {
    return productsInCart.keys.fold(0.0, (sum, id) {
      return sum! + getProductPrice(id) + getProductAddonsPrice(id);
    });
  }

  void setPaymentMethod(data) {
    paymentMethod = data;
  }

  // Returns the Product instance matching the provided id.
  Product? getProductById(String id) {
    return item[id];
  }

  // Returns the Product instance matching the provided id.
  ProductVariation? getProductVariationById(String key) {
    return productVariationInCart[key];
  }

  String? getCheckoutId() {
    return '';
  }

  void setUser(data) {
    user = data;
  }

  void loadSavedCoupon() {}

  bool isEnabledShipping() {
    return kPaymentConfig.enableShipping;
  }

  void setWalletAmount(double total) {
    walletAmount = total;
  }

  bool isWalletCart() {
    return false;
  }

  void addWalletProductToCart({
    required Product product,
    int quantity = 1,
  }) {
    final key = product.id.toString();
    item[product.id] = product;
    productsInCart[key] = quantity;

    currencyCode = kAdvanceConfig.defaultCurrency?.currencyCode;
  }

  void setTaxInfo(List<Tax> taxes, double taxesTotal) {
    this.taxes = taxes;
    this.taxesTotal = taxesTotal;
  }

  double getCODExtraFee() {
    final enabled = (kPaymentConfig.smartCOD?.enabled ?? false) &&
        ((paymentMethod?.id?.contains('cod') ?? false) ||
            (paymentMethod?.id?.contains('cashondelivery') ?? false));
    final extraFee = kPaymentConfig.smartCOD?.extraFee ?? 0;
    final amountStop = kPaymentConfig.smartCOD?.amountStop ?? 0;
    final subtotal = getSubTotal() ?? 0;
    return (enabled && extraFee > 0 && subtotal < amountStop) &&
            double.tryParse('$extraFee') != null
        ? double.parse('$extraFee')
        : 0;
  }

  /// Get product detail with quantity in the current cart
  List getProductsInCart() {
    var productList = [];
    for (var key in productsInCart.keys) {
      var productId = Product.cleanProductID(key);
      var product = getProductById(productId);

      if (product != null) {
        productList.add(
            {'id': key, 'product': product, 'quantity': productsInCart[key]});
      }
    }
    return productList;
  }
}
