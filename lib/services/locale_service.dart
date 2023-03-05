import 'package:devicelocale/devicelocale.dart';

class LocaleService {
  Future<String> getDeviceLanguage() async {
    final locale = await Devicelocale.currentLocale;
    return locale.toString().split('-').first.toLowerCase().split('_').first;
  }
}
