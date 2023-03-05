import 'package:provider/provider.dart';

import '../../app.dart';
import '../../services/service_config.dart';
import '../app_model.dart';

mixin LanguageMixin {
  String? get langCode => ServerConfig().isBuilder
      ? 'en'
      : Provider.of<AppModel>(App.fluxStoreNavigatorKey.currentContext!,
              listen: false)
          .langCode;
}
