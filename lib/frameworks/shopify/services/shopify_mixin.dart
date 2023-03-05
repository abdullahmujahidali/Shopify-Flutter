import '../../../services/service_config.dart';
import '../index.dart';
import 'shopify_service.dart';

mixin ShopifyMixin on ConfigMixin {
  @override
  void configShopify(appConfig) {
    final shopifyService = ShopifyService(
      domain: appConfig['url'],
      blogDomain: appConfig['blog'],
      accessToken: appConfig['accessToken'],
    );
    api = shopifyService;
    widget = ShopifyWidget(shopifyService);
  }
}
