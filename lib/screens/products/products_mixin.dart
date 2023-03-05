import 'dart:async';

import 'package:provider/provider.dart';

import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/product_model.dart';
import '../../modules/firebase/firebase_service.dart';
import '../../services/services.dart';

mixin ProductsMixin {
  Future<void> shareProductsLink(context) async {
    unawaited(
      FlashHelper.message(
        context,
        message: S.of(context).generatingLink,
        duration: const Duration(seconds: 2),
      ),
    );
    var productModel = Provider.of<ProductModel>(context, listen: false);
    var currentCategoryId = productModel.categoryId;
    var currentTagId = productModel.tagId;
    var url;
    if (currentCategoryId.isValid) {
      url = await FirebaseServices()
          .dynamicLinks
          ?.generateProductCategoryUrl(currentCategoryId);
    } else if (currentTagId != null) {
      url = await FirebaseServices()
          .dynamicLinks
          ?.generateProductTagUrl(currentTagId);
    }

    if (url.isNotEmpty) {
      Services().firebase.shareDynamicLinkProduct(itemUrl: url);
    } else {
      unawaited(
        FlashHelper.errorMessage(
          context,
          message: S.of(context).failedToGenerateLink,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

extension on String? {
  bool get isValid => this != null && this != '-1';
}
