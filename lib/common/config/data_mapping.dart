part of '../config.dart';

///-----FLUXSTORE LISTING-----///
class DataMapping {
  static final DataMapping _instance = DataMapping._internal();

  factory DataMapping() => _instance;

  DataMapping._internal();

  String? kProductPath;
  String? kCategoryPath;
  String? kLocationPath;
  late Map<String, dynamic> kProductDataMapping;
  late Map<String, dynamic> kCategoryDataMapping;
  late Map<String, dynamic> kCategoryImages;
  // this taxonomies are use for display the Listing detail
  late Map<String, dynamic> kTaxonomies;
  late Map<String, dynamic> kListingReviewMapping;

  void setMapping(
      String productPath,
      String categoryPath,
      String? locationPath,
      Map<String, dynamic> productDataMapping,
      Map<String, dynamic> categoryDataMapping,
      Map<String, dynamic> categoryImages,
      Map<String, dynamic> taxonomies,
      Map<String, dynamic> listingReviewMapping) {
    kLocationPath = locationPath;
    kProductPath = productPath;
    kCategoryPath = categoryPath;
    kProductDataMapping = Map<String, dynamic>.from(productDataMapping);
    kCategoryDataMapping = Map<String, dynamic>.from(categoryDataMapping);
    kCategoryImages = Map<String, dynamic>.from(categoryImages);
    kTaxonomies = Map<String, dynamic>.from(taxonomies);
    kListingReviewMapping = Map<String, dynamic>.from(listingReviewMapping);
  }
}
