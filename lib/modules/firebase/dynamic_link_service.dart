import 'package:flutter/material.dart';

class DynamicLinkService {
  void initDynamicLinks(BuildContext context) {}
  void shareProductLink({required String productUrl}) {}

  Future<void> handleDynamicLink(String url, BuildContext context) async {}
  Future<String> generateProductCategoryUrl(dynamic productCategoryId) =>
      Future.value('');
  Future<String> generateProductTagUrl(dynamic productTagId) =>
      Future.value('');
  Future<String> generateProductBrandUrl(dynamic brandCategoryId) =>
      Future.value('');
}
