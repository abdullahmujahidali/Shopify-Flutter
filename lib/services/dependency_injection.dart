// import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

// Enable Audio feature
// import '../modules/audio/services/audio_handler.dart';
import 'index.dart' show AudioManager, NotificationService, Services;
import 'location_service.dart';
import 'wallet/wallet_services.dart';
import 'wallet/wallet_services_impl.dart';

GetIt injector = GetIt.instance;

class DependencyInjection {
  static Future<void> inject() async {
    injector.allowReassignment = true;
    final locationService = LocationService();
    injector.registerSingleton<LocationService>(locationService);

    var notificationService = Services.getNotificationService();
    injector.registerSingleton<NotificationService>(notificationService);

    /// Enable Audio feature
    // if (kBlogDetail['enableAudioSupport'] ?? false) {
    //   injector.registerSingleton<AudioHandler>(await initAudioService());
    // }
    var audioService = Services().getAudioService();
    injector.registerLazySingleton<AudioManager>(() => audioService);

    /// Wallet services
    injector.registerLazySingleton<WalletServices>(WalletServicesImpl.new);
  }
}
