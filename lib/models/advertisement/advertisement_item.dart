import 'package:flutter/foundation.dart';

import '../../../common/constants.dart';
import 'advertisement_extension.dart';

class AdvertisementItem {
  late AdvertisementType type;
  late AdvertisementProvider provider;
  late String androidId;
  late String iosId;
  late List<String> showOnScreens;
  late List<String> hideOnScreens;
  late int waitingTimeToDisplay;

  AdvertisementItem({
    this.type = AdvertisementType.banner,
    this.provider = AdvertisementProvider.google,
    this.androidId = '',
    this.iosId = '',
    this.showOnScreens = const <String>[],
    this.hideOnScreens = const <String>[],
    this.waitingTimeToDisplay = 1,
  });

  String get id => isAndroid ? androidId : iosId;

  AdvertisementItem.fromJson(Map json) {
    androidId = json['androidId'] as String? ?? '';
    iosId = json['iosId'] as String? ?? '';
    showOnScreens = List.unmodifiable(json['showOnScreens'] ?? <String>[]);
    hideOnScreens = List.unmodifiable(json['hideOnScreens'] ?? <String>[]);
    waitingTimeToDisplay = json['waitingTimeToDisplay'] ?? 0;
    type = AdvertisementType.values
        .firstWhere((element) => describeEnum(element) == json['type']);
    provider = AdvertisementProvider.values
        .firstWhere((element) => describeEnum(element) == json['provider']);
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('type', describeEnum(type));
    writeNotNull('provider', describeEnum(provider));
    writeNotNull('androidId', androidId);
    writeNotNull('iosId', iosId);
    writeNotNull('waitingTimeToDisplay', waitingTimeToDisplay);
    writeNotNull('showOnScreens', showOnScreens);
    writeNotNull('hideOnScreens', hideOnScreens);
    return val;
  }

  AdvertisementItem copyWith({
    AdvertisementType? type,
    AdvertisementProvider? provider,
    String? androidId,
    String? iosId,
    List<String>? showOnScreens,
    List<String>? hideOnScreens,
    int? waitingTimeToDisplay,
  }) {
    return AdvertisementItem(
      type: type ?? this.type,
      provider: provider ?? this.provider,
      androidId: androidId ?? this.androidId,
      iosId: iosId ?? this.iosId,
      showOnScreens: showOnScreens?.toList() ?? List.from(this.showOnScreens),
      hideOnScreens: hideOnScreens?.toList() ?? List.from(this.hideOnScreens),
      waitingTimeToDisplay: waitingTimeToDisplay ?? 1,
    );
  }
}
