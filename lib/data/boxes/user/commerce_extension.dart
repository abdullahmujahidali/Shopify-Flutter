part of '../../boxes.dart';

extension UserCommerceSettingsExtension on UserBox {
  List<String> get recentSearches {
    return List<String>.from(
      box.get(
        BoxKeys.recentSearches,
        defaultValue: <String>[],
      ),
    );
  }

  set recentSearches(List<String> value) {
    if (value.isEmpty) {
      box.delete(BoxKeys.recentSearches);
      return;
    }
    box.put(BoxKeys.recentSearches, value);
  }

  List<String> get recentBlogsSearch {
    return List<String>.from(
      box.get(
        BoxKeys.recentBlogsSearch,
        defaultValue: <String>[],
      ),
    );
  }

  set recentBlogsSearch(List<String> value) {
    if (value.isEmpty) {
      box.delete(BoxKeys.recentBlogsSearch);
      return;
    }
    box.put(BoxKeys.recentBlogsSearch, value);
  }

  String get savedCoupon {
    return box.get(
      BoxKeys.savedCoupon,
      defaultValue: '',
    );
  }

  set savedCoupon(String value) {
    box.put(BoxKeys.savedCoupon, value);
  }

  List<Map> get orders {
    final rawData = box.get(
      BoxKeys.orders,
      defaultValue: <Map>[],
    );
    return List<Map>.from(rawData);
  }

  set orders(List<Map> value) {
    box.put(BoxKeys.orders, value);
  }

  List<Product> get wishList {
    final rawData = box.get(
      BoxKeys.wishList,
      defaultValue: <Product>[],
    );
    return List<Product>.from(
      rawData.map((e) => Product.fromLocalJson(e)),
    );
  }

  set wishList(List<Product> value) {
    if (value.isEmpty) {
      box.delete(BoxKeys.wishList);
      return;
    }
    final rawData = value.map((e) => e.toJson()).toList();
    box.put(BoxKeys.wishList, rawData);
  }

  List<Blog> get blogWishList {
    final rawData = box.get(
      BoxKeys.blogWishList,
      defaultValue: <Blog>[],
    );
    return List<Blog>.from(
      rawData.map((e) => Blog.fromLocalJson(e)),
    );
  }

  set blogWishList(List<Blog> value) {
    final rawData = value.map((e) => e.toJson()).toList();
    box.put(BoxKeys.blogWishList, rawData);
  }

  List? get recentProducts {
    return box.get(
      BoxKeys.recentProducts,
    );
  }

  set recentProducts(List? value) {
    if (value == null) {
      box.delete(BoxKeys.recentProducts);
      return;
    }
    box.put(BoxKeys.recentProducts, value);
  }

  List? get productsInCart {
    return box.get(
      BoxKeys.productsInCart,
    );
  }

  set productsInCart(List? value) {
    if (value == null) {
      box.delete(BoxKeys.productsInCart);
      return;
    }
    box.put(BoxKeys.productsInCart, value);
  }

  Address? get shippingAddress {
    final rawData = box.get(
      BoxKeys.shippingAddress,
      defaultValue: null,
    );
    return rawData != null ? Address.fromLocalJson(rawData) : null;
  }

  set shippingAddress(Address? value) {
    if (value == null) {
      box.delete(BoxKeys.shippingAddress);
      return;
    }
    final rawData = value.toJson();
    box.put(BoxKeys.shippingAddress, rawData);
  }

  List<Address>? get addresses {
    final rawData = box.get(
      BoxKeys.addresses,
      defaultValue: null,
    );
    return rawData != null && rawData is List<Map>
        ? List<Address>.from(
            rawData.map((e) => Address.fromLocalJson(e)),
          )
        : null;
  }

  set addresses(List<Address>? value) {
    if (value == null) {
      box.delete(BoxKeys.addresses);
      return;
    }
    final rawData = value.map((e) => e.toJsonEncodable()).toList();
    box.put(BoxKeys.addresses, rawData);
  }
}
