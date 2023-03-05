import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/error_codes/error_codes.dart';
import '../../services/service_config.dart';

class VendorOnBoardingServices {
  late final _url;
  late final _type;
  late final _platform;

  static final VendorOnBoardingServices _onBoardingServices =
      VendorOnBoardingServices._internal();

  factory VendorOnBoardingServices() {
    return _onBoardingServices;
  }

  VendorOnBoardingServices._internal() {
    _url = ServerConfig().url;
    _type = ServerConfig().type;
    if (_type == 'vendorAdmin') {
      _platform = ServerConfig().platform;
    } else {
      _platform = ServerConfig().typeName;
    }
  }

  Future<ErrorType> updateVendorInformation(token, data) async {
    try {
      var base64Str = EncodeUtils.encodeCookie(token);
      var endpoint = '$_url/wp-json/vendor-admin/profile';
      final response = await http.put(endpoint.toUri()!, body: {
        'token': base64Str,
        'data': jsonEncode(
          data,
        ),
        'platform': _platform,
      });
      if (jsonDecode(response.body)['response'] == 1) {
        return ErrorType.updateSuccess;
      }
      printLog('vendor_onboarding_services.dart: ${response.body}');
      return ErrorType.updateFailed;
    } catch (e) {
      printLog('vendor_onboarding_services.dart: $e');
      return ErrorType.updateFailed;
    }
  }

  Future<String> getAddressFromLocation(double? lat, double? long) async {
    var response = await http.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${isIos ? kGoogleApiKey.ios : kGoogleApiKey.android}'
            .toUri()!);
    var result = jsonDecode(response.body)['results'];
    return result.isNotEmpty ? result.first['formatted_address'] : '';
  }
}
