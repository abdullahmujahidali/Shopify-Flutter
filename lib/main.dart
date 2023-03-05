import 'dart:async';
import 'dart:io' show HttpClient, SecurityContext;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:universal_platform/universal_platform.dart';

import 'app.dart';
import 'common/config.dart';
import 'common/constants.dart';
import 'common/tools.dart';
import 'data/boxes.dart';
import 'env.dart';
import 'modules/webview/index.dart';
import 'services/dependency_injection.dart';
import 'services/locale_service.dart';
import 'services/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  printLog('Handling a background message ${message.messageId}');
}

void main() {
  printLog('[main] ===== START main.dart =======');
  WidgetsFlutterBinding.ensureInitialized();
  Configurations().setConfigurationValues(environment);

  /// Fix issue android sdk version 22 can not run the app.
  if (UniversalPlatform.isAndroid) {
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(Uint8List.fromList(isrgRootX1.codeUnits));
  }

  /// Support Webview (iframe) for Flutter Web. Requires this below header.
  /// Content-Security-Policy: frame-ancestors 'self' *.yourdomain.com
  registerWebViewWebImplementation();

  /// Hide status bar for splash screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

  Provider.debugCheckInvalidValueType = null;
  var languageCode = kAdvanceConfig.defaultLanguage;

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runZonedGuarded(() async {
    /// Init Hive boxes.
    await initBoxes();

    if (!foundation.kIsWeb) {
      /// Enable network traffic logging.
      HttpClient.enableTimelineLogging = !foundation.kReleaseMode;

      /// Lock portrait mode.
      unawaited(SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]));
    }

    await GmsCheck().checkGmsAvailability(enableLog: foundation.kDebugMode);

    try {
      if (isMobile) {
        /// Init Firebase settings due to version 0.5.0+ requires to.
        /// Use await to prevent any usage until the initialization is completed.
        await Services().firebase.init();
        await Configurations().loadRemoteConfig();
      }
    } catch (e) {
      printLog(e);
      printLog('🔴 Firebase init issue');
    }

    await DependencyInjection.inject();
    Services().setAppConfig(serverConfig);

    if (isMobile && kAdvanceConfig.autoDetectLanguage) {
      final lang = SettingsBox().languageCode;

      if (lang?.isEmpty ?? true) {
        languageCode = await LocaleService().getDeviceLanguage();
      } else {
        languageCode = lang.toString();
      }
    }

    if (serverConfig['type'] == 'vendorAdmin') {
      return runApp(Services()
          .getVendorAdminApp(languageCode: languageCode, isFromMV: false));
    }

    if (serverConfig['type'] == 'delivery') {
      return runApp(Services()
          .getDeliveryApp(languageCode: languageCode, isFromMV: false));
    }

    ResponsiveSizingConfig.instance.setCustomBreakpoints(
        const ScreenBreakpoints(desktop: 900, tablet: 600, watch: 100));
    runApp(App(languageCode: languageCode));
  }, printError);
}
