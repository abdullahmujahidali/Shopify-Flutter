import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:inspireui/inspireui.dart';

import '../firebase_remote_service.dart';

/// Implemennt Firebase Remote Config
///
class FirebaseRemoteServicesImpl extends FirebaseRemoteServices {
  @override
  String getString(String key) {
    return FirebaseRemoteConfig.instance.getString(key);
  }

  @override
  Future<bool> loadRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.fetch();
      await remoteConfig.activate();
      return true;
    } catch (e) {
      printLog('Unable to fetch remote config. Default value will be used. $e');
    }

    return false;
  }

  @override
  Future<List<String>> getKeys() async {
    return FirebaseRemoteConfig.instance.getAll().keys.toList();
  }
}
