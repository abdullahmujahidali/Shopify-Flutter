import 'package:flutter/foundation.dart';

import '../config.dart' show kAdType;
import '../constants.dart' show awesomeIcon;
import 'models/index.dart';

class ConfigurationUtils {
  static Map loadAdConfig(Map data) {
    final dataAdConfig = List.from([data]);
    if (data.isNotEmpty) {
      for (var e in kAdType.values) {
        if (describeEnum(e) == dataAdConfig[0]['type']) {
          dataAdConfig[0]['type'] = e;
        }
      }
      return dataAdConfig[0];
    }
    return data;
  }

  static List<Map> loadSmartChat(List<Map> data) {
    var dataSmartChat = List<Map<String, dynamic>>.from(data);
    for (var i = 0; i < dataSmartChat.length; i++) {
      var newData = Map<String, dynamic>.from(dataSmartChat[i]);
      newData['iconData'] = awesomeIcon[newData['iconData']];
      newData['imageData'] = newData['imageData'];
      dataSmartChat[i] = Map<String, dynamic>.from(newData);
    }
    return dataSmartChat;
  }

  static Map<String, GeneralSettingItem> loadSubGeneralSetting(Map data) {
    var subGeneralSetting = <String, GeneralSettingItem>{};
    data.forEach((key, value) {
      subGeneralSetting[key] = GeneralSettingItem.fromJson(value);
    });
    return subGeneralSetting;
  }
}
