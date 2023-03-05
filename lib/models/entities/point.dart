class Point {
  int? points;
  double? cartPriceRate;
  int? cartPointsRate;
  int? maxPointDiscount;
  int? maxProductPointDiscount;

  Point.fromJson(Map parsedJson) {
    points = parsedJson['points'];
    cartPriceRate = parsedJson['cart_price_rate'].toDouble();
    cartPointsRate = parsedJson['cart_points_rate'];
    maxPointDiscount = parsedJson['max_point_discount'];
    maxProductPointDiscount = parsedJson['max_product_point_discount'];
  }
}
