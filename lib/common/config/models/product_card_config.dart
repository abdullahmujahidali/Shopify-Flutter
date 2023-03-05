import '../../../modules/dynamic_layout/helper/helper.dart';

class ProductCardConfig {
  bool hidePrice = false;
  bool hideStore = false;
  bool hideTitle = false;
  num? borderRadius;
  bool enableRating = true;
  bool showCartButton = false;
  bool showCartIcon = true;
  bool showCartIconColor = false;
  bool showCartButtonWithQuantity = false;
  bool hideEmptyProductListRating = false;
  Map? boxShadow;
  String boxFit = 'cover';
  String cardDesign = 'card';
  int? titleLine;
  String? order;
  String? orderby;
  num vMargin = 0.0;
  num hMargin = 6.0;


  ProductCardConfig({
    this.hidePrice = false,
    this.hideStore = false,
    this.hideTitle = false,
    this.borderRadius,
    this.enableRating = true,
    this.showCartButton = false,
    this.showCartIcon = true,
    this.showCartIconColor = false,
    this.showCartButtonWithQuantity = false,
    this.hideEmptyProductListRating = false,
    this.boxFit = 'cover',
    this.boxShadow,
    this.cardDesign = 'card',
    this.titleLine,
    this.order,
    this.orderby,
    this.vMargin = 0.0,
    this.hMargin = 6.0,
  });

  ProductCardConfig.fromJson(dynamic json) {
    hidePrice = json['hidePrice'] ?? false;
    hideStore = json['hideStore'] ?? false;
    hideTitle = json['hideTitle'] ?? false;
    borderRadius = json['borderRadius'];
    enableRating = json['enableRating'] ?? true;
    showCartButton = json['showCartButton'] ?? false;
    showCartIcon = json['showCartIcon'] ?? true;
    showCartIconColor = json['showCartIconColor'] ?? false;
    showCartButtonWithQuantity = json['showCartButtonWithQuantity'] ?? false;
    hideEmptyProductListRating = json['hideEmptyProductListRating'] ?? false;
    boxShadow = json['boxShadow'];
    boxFit = json['boxFit'] ?? 'cover';
    cardDesign = json['cardDesign'] ?? 'card';
    titleLine = Helper.formatInt(json['titleLine']);
    order = json['order'];
    orderby = json['orderby'];
    vMargin = json['vMargin'] ?? 0.0;
    hMargin = json['hMargin'] ?? 6.0;
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['hidePrice'] = hidePrice;
    map['hideStore'] = hideStore;
    map['hideTitle'] = hideTitle;
    map['borderRadius'] = borderRadius;
    map['enableRating'] = enableRating;
    map['showCartButton'] = showCartButton;
    map['showCartIcon'] = showCartIcon;
    map['showCartIconColor'] = showCartIconColor;
    map['showCartButtonWithQuantity'] = showCartButtonWithQuantity;
    map['hideEmptyProductListRating'] = hideEmptyProductListRating;
    map['boxShadow'] = boxShadow;
    map['boxFit'] = boxFit;
    map['cardDesign'] = cardDesign;
    map['titleLine'] = titleLine;
    map['order'] = order;
    map['orderby'] = orderby;
    map['vMargin'] = vMargin;
    map['hMargin'] = hMargin;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
