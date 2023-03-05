part of '../../boxes.dart';

extension UserGeneralSettingsExtension on UserBox {
  bool get isLoggedIn {
    return box.get(
      BoxKeys.isLoggedIn,
      defaultValue: false,
    );
  }

  set isLoggedIn(bool value) {
    box.put(BoxKeys.isLoggedIn, value);
  }

  bool get hasAgreedPrivacy {
    return box.get(
      BoxKeys.hasAgreedPrivacy,
      defaultValue: false,
    );
  }

  set hasAgreedPrivacy(bool value) {
    box.put(BoxKeys.hasAgreedPrivacy, value);
  }

  bool get hasAnswerAgeRestriction {
    return box.get(
      BoxKeys.hasAnswerAgeRestriction,
      defaultValue: false,
    );
  }

  set hasAnswerAgeRestriction(bool value) {
    box.put(BoxKeys.hasAnswerAgeRestriction, value);
  }

  String? get userCookie {
    return box.get(
      BoxKeys.userCookie,
      defaultValue: null,
    );
  }

  set userCookie(String? value) {
    if (value == null) {
      box.delete(BoxKeys.userCookie);
      return;
    }
    box.put(BoxKeys.userCookie, value);
  }

  User? get userInfo {
    final rawData = box.get(
      BoxKeys.userInfo,
      defaultValue: null,
    );
    return rawData != null ? User.fromLocalJson(rawData) : null;
  }

  set userInfo(User? value) {
    if (value == null) {
      box.delete(BoxKeys.userInfo);
      return;
    }
    final rawData = value.toJson();
    box.put(BoxKeys.userInfo, rawData);
  }

  User? get deliveryUser {
    final Map? rawData = box.get(
      BoxKeys.deliveryUser,
    );
    if (rawData == null || rawData.isEmpty) {
      return null;
    }
    return User.fromLocalJson(rawData);
  }

  set deliveryUser(User? value) {
    if (value == null) {
      box.delete(BoxKeys.deliveryUser);
      return;
    }
    final rawData = value.toJson();
    box.put(BoxKeys.deliveryUser, rawData);
  }

  User? get vendorUser {
    final Map? rawData = box.get(
      BoxKeys.vendorUser,
    );
    if (rawData == null || rawData.isEmpty) {
      return null;
    }
    return User.fromLocalJson(rawData);
  }

  set vendorUser(User? value) {
    if (value == null) {
      box.delete(BoxKeys.vendorUser);
      return;
    }
    final rawData = value.toJson();
    box.put(BoxKeys.vendorUser, rawData);
  }

  String? get opencartCookie {
    return box.get(
      BoxKeys.opencartCookie,
    );
  }

  set opencartCookie(String? value) {
    if (value == null) {
      box.delete(BoxKeys.opencartCookie);
      return;
    }
    box.put(BoxKeys.opencartCookie, value);
  }

  Address get posAddress {
    final Map? rawData = box.get(
      BoxKeys.posAddress,
    );
    if (rawData == null || rawData.isEmpty) {
      return Address.fromJson({});
    }
    return Address.fromLocalJson(rawData);
  }

  set posAddress(Address? value) {
    if (value == null) {
      box.delete(BoxKeys.posAddress);
      return;
    }
    final rawData = value.toJson();
    box.put(BoxKeys.posAddress, rawData);
  }

  FStoreNotification? get notification {
    final Map? rawData = box.get(
      BoxKeys.notification,
    );
    if (rawData == null || rawData.isEmpty) {
      return null;
    }
    return FStoreNotification.fromJson(rawData);
  }

  set notification(FStoreNotification? value) {
    if (value == null) {
      box.delete(BoxKeys.notification);
      return;
    }
    final rawData = value.toJson();
    box.put(BoxKeys.notification, rawData);
  }
}
