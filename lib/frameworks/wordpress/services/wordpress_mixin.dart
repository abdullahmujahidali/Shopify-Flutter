import '../../../services/index.dart';
import '../index.dart';
import 'wordpress_service.dart';

mixin WordPressMixin on ConfigMixin {
  @override
  void configWordPress(appConfig) {
    final wordpressService = WordPressService(
      domain: appConfig['url'],
    );
    api = wordpressService;
    widget = WordPressWidget();
    if (injector.isRegistered<WordPressService>()) {
      injector.unregister<WordPressService>();
    }
    injector.registerSingleton<WordPressService>(wordpressService);
  }
}
