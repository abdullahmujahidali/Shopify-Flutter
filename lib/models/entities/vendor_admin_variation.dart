class VendorAdminVariation {
  int? id;
  bool? isActive;
  bool? isManageStock = false;
  int? stockQuantity = 0;
  String? regularPrice;
  String? salePrice;
  Map<String?, dynamic>? attributes;
  Map<String?, dynamic>? slugs = {};
  VendorAdminVariation() {
    id = -1;
    isActive = true;
    isManageStock = false;
    stockQuantity = 0;
    regularPrice = '';
    salePrice = '';
    attributes = {};
    slugs = {};
  }

  VendorAdminVariation.fromJson(json) {
    id = json['variation_id'];
    isActive = json['variation_is_active'];
    if (json['max_qty'] is int) {
      stockQuantity = json['max_qty'];
    }
    if (json['manage_stock'] is String) {
      isManageStock = false;
    } else {
      isManageStock = json['manage_stock'];
    }

    try {
      regularPrice = json['display_regular_price'].toString();
    } on Exception {
      regularPrice = '0.0';
    }
    try {
      salePrice = json['display_price'].toString();
    } on Exception {
      salePrice = '';
    }
    attributes = (json['attributes'] is List) ? {} : json['attributes'];
    slugs = (json['slugs'] is List) ? {} : json['slugs'];
  }

  Map toJson() {
    return {
      'variation_id': id,
      'variation_is_active': isActive,
      'max_qty': isManageStock! ? stockQuantity : '',
      'manage_stock': isManageStock,
      'display_regular_price': regularPrice,
      'display_price': salePrice,
      'attributes': attributes,
      'slugs': slugs,
    };
  }
}
