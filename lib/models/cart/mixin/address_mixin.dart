import 'dart:async';

import 'package:quiver/strings.dart';

import '../../../common/config.dart';
import '../../../data/boxes.dart';
import '../../../services/index.dart';
import '../../entities/address.dart';
import '../../entities/shipping_method.dart';
import 'cart_mixin.dart';

mixin AddressMixin on CartMixin {
  Address? address;
  ShippingMethod? shippingMethod;

  void saveShippingAddress(Address? address) {
    UserBox().shippingAddress = address;
  }

  Future<Address?> getShippingAddress() async {
    if (ServerConfig().isVendorManagerType()) {
      return null;
    }
    try {
      final address = UserBox().shippingAddress;
      if (address != null) {
        return address;
      } else {
        // final userJson = storage.getItem(kLocalKey['userInfo']!);
        final userInfo = UserBox().userInfo;

        if (userInfo != null) {
          var user = await Services().api.getUserInfo(userInfo.cookie);
          if (user != null) {
            user.isSocial = userInfo.isSocial;
          } else {
            user = userInfo;
          }

          if (user.billing == null) {
            final info = await Services().api.getCustomerInfo(user.id)!;
            if (info['billing'] != null) {
              return info['billing'];
            }
          }

          return Address(
              firstName:
                  user.billing != null && user.billing!.firstName!.isNotEmpty
                      ? user.billing!.firstName
                      : user.firstName,
              lastName:
                  user.billing != null && user.billing!.lastName!.isNotEmpty
                      ? user.billing!.lastName
                      : user.lastName,
              email: user.billing != null && user.billing!.email!.isNotEmpty
                  ? user.billing!.email
                  : user.email,
              street: user.billing != null && user.billing!.address1!.isNotEmpty
                  ? user.billing!.address1
                  : '',
              country: user.billing != null && isNotBlank(user.billing!.country)
                  ? user.billing!.country
                  : kPaymentConfig.defaultCountryISOCode,
              state: user.billing != null && user.billing!.state!.isNotEmpty
                  ? user.billing!.state
                  : kPaymentConfig.defaultStateISOCode,
              phoneNumber:
                  user.billing != null && user.billing!.phone!.isNotEmpty
                      ? user.billing!.phone
                      : '',
              city: user.billing != null && user.billing!.city!.isNotEmpty
                  ? user.billing!.city
                  : '',
              zipCode:
                  user.billing != null && user.billing!.postCode!.isNotEmpty
                      ? user.billing!.postCode
                      : '');
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  void clearAddress() {
    address = null;
  }

  void setAddress(data) {
    address = data;
    saveShippingAddress(data);
  }

  Future<Address?> getAddress() async {
    address ??= await getShippingAddress();
    return address;
  }

  double? getShippingCost() {
    if (shippingMethod != null && shippingMethod!.cost! > 0) {
      return shippingMethod!.cost;
    }
    if (shippingMethod != null && isNotBlank(shippingMethod!.classCost)) {
      List items = shippingMethod!.classCost!.split('*');
      String cost = items[0] != '[qty]' ? items[0] : items[1];
      var shippingCost = double.parse(cost);
      var count = 0;

      for (var key in productsInCart.keys) {
        count += productsInCart[key]!;
      }

      return shippingCost * count;
    }
    return 0.0;
  }

  void setShippingMethod(data) {
    shippingMethod = data;
  }
}
